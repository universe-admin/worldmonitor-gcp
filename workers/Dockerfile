# Phase 4 — AI worker image. Built by Cloud Build into Artifact Registry and run
# on private compute (Cloud Run internal ingress / GCE) — Phases 10 & 16.
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ai_worker.py db.py ./

# Streaming pull worker — no port to expose. It runs until SIGTERM.
CMD ["python", "ai_worker.py"]
