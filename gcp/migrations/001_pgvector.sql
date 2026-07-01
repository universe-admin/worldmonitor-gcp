-- Phase 11 — Search. Enable pgvector on the knowledge_graph database and create
-- the embedding + knowledge tables the AI workers read/write.
--
-- Apply against the knowledge_graph DB on the Cloud SQL instance, e.g. via the
-- seeders Cloud Run Job or:
--   cloud-sql-proxy $(terraform output -raw sql_connection_name) &
--   psql "host=127.0.0.1 dbname=knowledge_graph user=uvm_app" -f 001_pgvector.sql
--
-- Dimension note: 768 matches Vertex AI `text-embedding-005`. If you embed with a
-- different model (e.g. OpenAI 1536-dim), change vector(768) accordingly before
-- inserting — pgvector dimensions are fixed per column.

CREATE EXTENSION IF NOT EXISTS vector;

-- Entities in the knowledge graph (people, orgs, places, assets, events).
CREATE TABLE IF NOT EXISTS entities (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kind         TEXT        NOT NULL,           -- 'person' | 'org' | 'place' | 'event' | ...
    name         TEXT        NOT NULL,
    attributes   JSONB       NOT NULL DEFAULT '{}',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Documents ingested from OSINT feeds / uploads, with their vector embedding.
CREATE TABLE IF NOT EXISTS documents (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source       TEXT        NOT NULL,           -- feed id / bucket path
    title        TEXT,
    body         TEXT        NOT NULL,
    embedding    vector(768),                    -- NULL until embedded
    metadata     JSONB       NOT NULL DEFAULT '{}',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Approximate-nearest-neighbour index for semantic search over documents.
-- IVFFlat needs data before it can be built well; run ANALYZE after bulk load.
CREATE INDEX IF NOT EXISTS documents_embedding_ivfflat
    ON documents USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 100);

-- Edges between entities (typed relationships), optionally sourced from a document.
CREATE TABLE IF NOT EXISTS relationships (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    src_id       BIGINT      NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    dst_id       BIGINT      NOT NULL REFERENCES entities(id) ON DELETE CASCADE,
    relation     TEXT        NOT NULL,
    document_id  BIGINT      REFERENCES documents(id) ON DELETE SET NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS relationships_src_idx ON relationships (src_id);
CREATE INDEX IF NOT EXISTS relationships_dst_idx ON relationships (dst_id);
