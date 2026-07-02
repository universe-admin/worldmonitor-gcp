"""Universe Monitor — AI worker (Phases 10 & 16).

A private, long-running worker that drives the ingestion pipeline:

    Cloud Scheduler / connectors -> Pub/Sub -> (this worker) -> GCS + Cloud SQL

It streaming-pulls the `ai-jobs`, `osint-feed`, and `document-processing`
subscriptions and, for each message, uses Claude to turn raw OSINT text into a
structured intelligence record, then lands the result in Postgres (and the raw
payload in Cloud Storage). Runs on private compute (Cloud Run internal ingress /
GCE), reaching Cloud SQL + Secret Manager over the VPC connector.

Config comes entirely from the environment; on Cloud Run these are wired from
Secret Manager and the Terraform outputs (see workers.tf / run.tf). Nothing is
hardcoded.

    ANTHROPIC_API_KEY            (Secret Manager: anthropic-api-key)
    GCP_PROJECT                  project id
    SUBSCRIPTIONS                comma-separated pull subscription ids
    RAW_BUCKET                   GCS bucket for raw payloads (e.g. <project>-raw-data)
    DB_*                         Cloud SQL connection (host/name/user/password)
"""

from __future__ import annotations

import json
import logging
import os
import signal
import sys
from concurrent.futures import TimeoutError as FuturesTimeoutError

import anthropic
from google.cloud import pubsub_v1, storage

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("ai-worker")

# The latest, most capable Claude model. Adaptive thinking + streaming per the
# Anthropic guidance for potentially long outputs.
MODEL = os.environ.get("LLM_MODEL", "claude-opus-4-8")

PROJECT = os.environ["GCP_PROJECT"]
SUBSCRIPTIONS = [s.strip() for s in os.environ.get("SUBSCRIPTIONS", "").split(",") if s.strip()]
RAW_BUCKET = os.environ.get("RAW_BUCKET", "")

_anthropic = anthropic.Anthropic()  # reads ANTHROPIC_API_KEY from the environment
_storage = storage.Client(project=PROJECT)

SYSTEM_PROMPT = (
    "You are an OSINT analyst for a global-intelligence platform. Given a raw "
    "feed item, extract a concise structured record. Respond with a factual "
    "briefing; do not speculate beyond the source text."
)

# Structured-output schema: guarantees valid, parseable JSON back from Claude.
OUTPUT_SCHEMA = {
    "type": "object",
    "properties": {
        "summary": {"type": "string"},
        "category": {
            "type": "string",
            "enum": ["geopolitics", "markets", "aviation", "maritime", "energy", "other"],
        },
        "entities": {"type": "array", "items": {"type": "string"}},
        "severity": {"type": "integer"},
    },
    "required": ["summary", "category", "entities", "severity"],
    "additionalProperties": False,
}


def analyze(raw_text: str) -> dict:
    """Turn a raw feed item into a structured intelligence record via Claude."""
    # Stream so large outputs don't hit request timeouts; collect the final message.
    with _anthropic.messages.stream(
        model=MODEL,
        max_tokens=2048,
        system=SYSTEM_PROMPT,
        thinking={"type": "adaptive"},
        output_config={"format": {"type": "json_schema", "schema": OUTPUT_SCHEMA}},
        messages=[{"role": "user", "content": raw_text}],
    ) as stream:
        message = stream.get_final_message()

    if message.stop_reason == "refusal":
        raise RuntimeError(f"model refused: {getattr(message, 'stop_details', None)}")

    text = next((b.text for b in message.content if b.type == "text"), "{}")
    return json.loads(text)


def persist(record: dict, raw_text: str, message_id: str) -> None:
    """Land the raw payload in GCS and the structured record in Postgres."""
    if RAW_BUCKET:
        blob = _storage.bucket(RAW_BUCKET).blob(f"osint/{message_id}.txt")
        blob.upload_from_string(raw_text, content_type="text/plain")

    # DB write is deferred to db.insert_document so this module stays import-light
    # for environments that only need the analysis path (e.g. unit tests).
    from db import insert_document  # local import: optional psycopg dependency

    insert_document(source=f"pubsub/{message_id}", body=record["summary"], metadata=record)


def make_callback():
    def callback(message: "pubsub_v1.subscriber.message.Message") -> None:
        raw_text = message.data.decode("utf-8", errors="replace")
        try:
            record = analyze(raw_text)
            persist(record, raw_text, message.message_id)
            log.info("processed %s (%s)", message.message_id, record.get("category"))
            message.ack()
        except Exception:  # noqa: BLE001 — nack and let Pub/Sub redeliver
            log.exception("failed to process %s", message.message_id)
            message.nack()

    return callback


def main() -> int:
    if not SUBSCRIPTIONS:
        log.error("SUBSCRIPTIONS is empty; nothing to consume")
        return 1

    subscriber = pubsub_v1.SubscriberClient()
    callback = make_callback()
    futures = []
    for sub in SUBSCRIPTIONS:
        path = subscriber.subscription_path(PROJECT, sub)
        futures.append(subscriber.subscribe(path, callback=callback))
        log.info("subscribed to %s", path)

    # Graceful shutdown on SIGTERM (Cloud Run / GCE instance stop).
    def _shutdown(*_):
        log.info("shutting down; cancelling subscribers")
        for f in futures:
            f.cancel()

    signal.signal(signal.SIGTERM, _shutdown)

    with subscriber:
        for f in futures:
            try:
                f.result()
            except FuturesTimeoutError:
                f.cancel()
            except Exception:  # noqa: BLE001
                log.exception("subscriber stopped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
