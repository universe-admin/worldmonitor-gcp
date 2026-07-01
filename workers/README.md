# workers/ — private AI worker (Phases 10 & 16)

The autonomous layer of the plan: a private, long-running worker that consumes the
Pub/Sub topics and turns raw OSINT into structured intelligence with Claude, then
lands results in Cloud SQL (`knowledge_graph`) and Cloud Storage.

```
Cloud Scheduler / connectors → Pub/Sub → ai_worker.py → GCS (raw) + Postgres (structured)
```

| File | Purpose |
|---|---|
| [`ai_worker.py`](ai_worker.py) | Streaming-pull worker over `ai-jobs` / `osint-feed` / `document-processing`; calls Claude (`claude-opus-4-8`, adaptive thinking, structured output). |
| [`db.py`](db.py) | Postgres helpers for the `documents` / knowledge-graph tables. |
| [`Dockerfile`](Dockerfile) | Worker image (built by `gcp/cloudbuild.yaml`). |
| [`requirements.txt`](requirements.txt) | Runtime deps. |

## Configuration (all via env)

Wired from Secret Manager + Terraform outputs on Cloud Run (`gcp/terraform/workers.tf`):

| Var | Source |
|---|---|
| `ANTHROPIC_API_KEY` | Secret Manager `anthropic-api-key` |
| `GCP_PROJECT` | project id |
| `SUBSCRIPTIONS` | comma-separated pull subscription ids (e.g. `ai-jobs-workers,osint-feed-workers`) |
| `RAW_BUCKET` | `<project>-raw-data` |
| `DB_HOST` / `DB_NAME` / `DB_USER` / `DB_PASSWORD` | Cloud SQL private IP + `db-password` secret |
| `LLM_MODEL` | optional model override (default `claude-opus-4-8`) |

## Run locally

```bash
pip install -r requirements.txt
export GCP_PROJECT=aihumane-prod ANTHROPIC_API_KEY=sk-ant-...
export SUBSCRIPTIONS=ai-jobs-workers RAW_BUCKET=aihumane-prod-raw-data
export DB_HOST=127.0.0.1 DB_PASSWORD=...   # via cloud-sql-proxy
python ai_worker.py
```

## Deploy

Cloud Build builds the image; `gcp/terraform/workers.tf` runs it as a Cloud Run
service with `min-instances = 1` (a streaming pull worker must stay warm) on the
private network. Before first run, apply the pgvector migration:

```bash
psql "$(terraform output -raw sql_connection_name ...)" -f ../gcp/migrations/001_pgvector.sql
```

## Scope note

This is a **starter** worker: one analysis path (OSINT → structured record). The
broader autonomous stack from the plan (Claude Code agents, MCP servers,
Playwright, task queue) layers on top of this consumer loop. Embedding population
for pgvector search (Phase 11) is a follow-up — the column and index exist; wire a
Vertex AI / OpenAI embedding call into `db.insert_document`.
