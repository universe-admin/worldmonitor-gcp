# worldmonitor-gcp

Cloud-native **GCP deployment** for **Universe Monitor** — a Palantir-style intelligence
platform built on [World Monitor](https://github.com/koala73/worldmonitor), the
open-source (AGPL-3.0) real-time global-intelligence dashboard (3D globe/map, hundreds of
RSS sources, AI briefings, geopolitics/markets/aviation/maritime/energy tracking, and a
39-tool MCP server).

This repo holds **deployment infrastructure only** — it does not fork the application
source. The app is built from the upstream image/source at
[`koala73/worldmonitor`](https://github.com/koala73/worldmonitor).

> Status: 🚧 active. The GCP infrastructure-as-code under [`gcp/terraform/`](gcp/terraform/)
> now implements the 17-phase cloud-native plan (project `aihumane-prod`, domain
> `aihumane.in`). Per-phase progress is tracked in [`docs/roadmap.md`](docs/roadmap.md);
> the target design is in [`docs/architecture.md`](docs/architecture.md).

## Why this repo

The local Docker self-host path works but is heavy to operate (multiple containers +
a bundled Redis REST proxy + AIS relay, plus Ollama for local AI). Moving it to GCP
gives managed Redis, autoscaling, secret management, and a buildable CI path — without
running anything on a workstation.

## What's here

> **Want the dashboard live and shareable now?** See [docs/hosting.md](docs/hosting.md) —
> `./gcp/deploy-mvp.sh <project>` from Cloud Shell gives you a public HTTPS URL in ~10 min.

| Path | Purpose |
|---|---|
| [`gcp/deploy-mvp.sh`](gcp/deploy-mvp.sh) | One-command MVP deploy → public Cloud Run URL (see [docs/hosting.md](docs/hosting.md)). |
| [`docker-compose.override.example.yml`](docker-compose.override.example.yml) | Local-stack overlay template (Ollama wiring + optional data-feed keys). Copy to `docker-compose.override.yml` (gitignored) and fill in. |
| [`.env.example`](.env.example) | Required secrets + optional feed keys for the local/self-host stack. Copy to `.env` (gitignored). |
| [`gcp/terraform/`](gcp/terraform/) | GCP infrastructure-as-code: APIs, VPC, IAM, Artifact Registry, Cloud Run, Cloud SQL, Memorystore, GCS, Pub/Sub, Secret Manager, HTTPS LB + Cloud Armor, Cloud DNS, monitoring. |
| [`gcp/cloudbuild.yaml`](gcp/cloudbuild.yaml) | Cloud Build CI/CD: build app + worker images → Artifact Registry → deploy Cloud Run (Phase 13). |
| [`workers/`](workers/) | Private AI worker (Phases 10 & 16): Pub/Sub → Claude → Cloud SQL / Cloud Storage. |
| [`docs/roadmap.md`](docs/roadmap.md) | Phase-by-phase progress tracker for the 17-step cloud-native plan. |
| [`docs/architecture.md`](docs/architecture.md) | Target GCP architecture and the (now resolved) design decisions. |

## Quick start (local, for reference)

```bash
git clone https://github.com/koala73/worldmonitor.git
cd worldmonitor
npm install
# bring our secrets + override in:
cp /path/to/.env .env
cp /path/to/docker-compose.override.yml .
docker compose up -d
./scripts/run-seeders.sh
# dashboard at http://localhost:3000
```

The MCP server is served at `/api/mcp` (or the `/mcp` rewrite). On a **self-hosted**
instance, auth is just an env var — set `WORLDMONITOR_VALID_KEYS=wm_<40-hex>` and call
the MCP with header `X-WorldMonitor-Key: wm_<hex>` (no OAuth).

## License

Deployment configuration in this repo is provided as-is. The deployed application,
World Monitor, is licensed **AGPL-3.0-only** by its authors — see
[`NOTICE`](NOTICE) and the upstream repository.
