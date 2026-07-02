"""Postgres access for the AI worker (Phase 6 / Phase 11).

Thin helpers over the knowledge_graph database. Connection params come from the
environment; the password is mounted from Secret Manager on Cloud Run. Embeddings
are optional — populate `documents.embedding` later with a Vertex AI / OpenAI
embedding call (the pgvector column is created by gcp/migrations/001_pgvector.sql).
"""

from __future__ import annotations

import json
import os

import psycopg


def _conninfo() -> str:
    # On Cloud Run, DB_HOST is the Cloud SQL private IP (or a unix socket path via
    # the Cloud SQL connector). Terraform surfaces both via outputs.
    return (
        f"host={os.environ['DB_HOST']} "
        f"dbname={os.environ.get('DB_NAME', 'knowledge_graph')} "
        f"user={os.environ.get('DB_USER', 'uvm_app')} "
        f"password={os.environ['DB_PASSWORD']}"
    )


def insert_document(source: str, body: str, metadata: dict, title: str | None = None) -> int:
    """Insert one analysed document; returns its id. Embedding is left NULL."""
    with psycopg.connect(_conninfo(), autocommit=True) as conn:
        row = conn.execute(
            """
            INSERT INTO documents (source, title, body, metadata)
            VALUES (%s, %s, %s, %s)
            RETURNING id
            """,
            (source, title, body, json.dumps(metadata)),
        ).fetchone()
    return int(row[0])
