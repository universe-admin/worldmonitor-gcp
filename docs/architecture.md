# GCP target architecture

Goal: run World Monitor as a managed, autoscaling, cloud-native stack on GCP — no
workstation dependency — while preserving the "local AI, no per-call API keys" property
via self-hosted Ollama.

## Upstream stack (what we're deploying)

From [`koala73/worldmonitor`](https://github.com/koala73/worldmonitor):

- **Frontend** — Vite + TypeScript SPA (globe.gl/Three.js, deck.gl/MapLibre). Static build.
- **API** — Vercel-style serverless routes under `api/` (incl. `api/mcp/*`, the 39-tool
  MCP server). Served as one Node app in the Docker image.
- **Redis** — used for cross-user caching / dedup. App talks to an **Upstash-compatible
  REST** endpoint (`UPSTASH_REDIS_REST_URL` / `UPSTASH_REDIS_REST_TOKEN`), not raw RESP.
  The compose stack bundles `redis` + a `redis-rest` proxy to provide that REST shape.
- **AIS relay** — separate service for maritime AIS; auth'd via `RELAY_SHARED_SECRET`.
- **Seeders** — `scripts/run-seeders.sh` (host Node) load initial data into Redis.
- **AI briefings** — any OpenAI-compatible `LLM_API_URL`; we use Ollama for local AI.

## Proposed GCP mapping (recommended: Cloud Run-first)

| Component | GCP service | Notes |
|---|---|---|
| App (frontend + `api/` + MCP) | **Cloud Run** service `worldmonitor` | Build the repo's Docker image; min-instances ≥1 to avoid cold MCP calls. |
| AIS relay | **Cloud Run** service `ais-relay` | Internal ingress; reached by the app over the VPC. |
| Redis | **Memorystore for Redis** | Managed RESP. *Gap:* app wants a REST endpoint → run the upstream `redis-rest` proxy as a small Cloud Run sidecar service in front of Memorystore, exposing `UPSTASH_REDIS_REST_URL`. |
| Redis REST proxy | **Cloud Run** service `redis-rest` | Bridges Memorystore ↔ the Upstash REST contract the app expects. |
| Local AI (Ollama) | **Cloud Run with GPU** (or a GCE GPU VM) | Cloud Run now supports GPUs; host `ollama serve` + a pulled model. `LLM_API_URL` points here. GCE GPU VM is the cheaper always-on alternative. |
| Secrets | **Secret Manager** | `RELAY_SHARED_SECRET`, `REDIS_PASSWORD`, `REDIS_TOKEN`, `WORLDMONITOR_VALID_KEYS`, feed keys — mounted as env at deploy. |
| Image registry | **Artifact Registry** | `gcr`-style repo for the built images. |
| CI / build | **Cloud Build** | Build from upstream source (or a pinned commit) → push to Artifact Registry → deploy Cloud Run. |
| Networking | **Serverless VPC connector** | So Cloud Run services reach Memorystore (private IP) and each other. |
| Seeders | **Cloud Run Job** | One-shot job that runs `run-seeders.sh` against Memorystore after deploy. |

### Alternative: GKE Autopilot
If you'd rather keep the compose topology 1:1 (sidecars, the relay, the proxy) and want
finer control, GKE Autopilot maps the `docker-compose.yml` services to Deployments +
Services with a Memorystore (or in-cluster Redis) backend. Heavier ops than Cloud Run.

## Open decisions (to confirm before building `gcp/`)

1. **Runtime:** Cloud Run-first (recommended) vs GKE Autopilot.
2. **Ollama hosting:** Cloud Run GPU (scales to zero, pricier per-hour) vs always-on GCE
   GPU VM (cheaper steady-state) vs dropping local-AI in favor of a managed LLM.
3. **MCP exposure:** public `/api/mcp` behind the `X-WorldMonitor-Key` header (simple) vs
   restoring the upstream OAuth gate.
4. **Region** and **project id**.
5. **Build source:** build from upstream `main` (auto-updating) vs a pinned commit/tag
   (reproducible).

## IaC plan (`gcp/`)

Target: **Terraform** for infra (Artifact Registry, Memorystore, VPC connector, Secret
Manager, Cloud Run services, IAM) + a **Cloud Build** config for build-and-deploy. To be
added once the decisions above are settled.
