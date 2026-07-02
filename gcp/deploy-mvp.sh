#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Universe Monitor — MVP deploy (fast path to a shareable dashboard)
#
# Deploys the World Monitor dashboard to a single public Cloud Run service and
# prints its shareable HTTPS URL (https://worldmonitor-....run.app). This is the
# minimal hosting tier from docs/roadmap.md — no load balancer, no custom
# domain, no Cloud SQL. The full 17-phase stack is `gcp/terraform/` instead.
#
# Run it in Google Cloud Shell (https://shell.cloud.google.com — nothing to
# install, already authenticated):
#
#   git clone -b claude/universe-monitor-hosting-77vdio \
#       https://github.com/universe-admin/worldmonitor-gcp.git
#   cd worldmonitor-gcp
#   ./gcp/deploy-mvp.sh <PROJECT_ID> [REGION]
#
# Optional env (export before running; each unlocks a data layer / feature):
#   UPSTASH_REDIS_REST_URL / UPSTASH_REDIS_REST_TOKEN   cross-user cache (free
#       tier at upstash.com; the dashboard runs without it, uncached)
#   GROQ_API_KEY or OPENROUTER_API_KEY                  AI briefings
#   FINNHUB_API_KEY FRED_API_KEY EIA_API_KEY NASA_FIRMS_API_KEY
#   ACLED_EMAIL ACLED_PASSWORD AVIATIONSTACK_API AISSTREAM_API_KEY
#   WORLDMONITOR_VALID_KEYS                             MCP API key(s), wm_<40hex>
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROJECT_ID="${1:?usage: deploy-mvp.sh <PROJECT_ID> [REGION]}"
REGION="${2:-us-central1}"
SERVICE="worldmonitor"
REPO="universe-monitor"
UPSTREAM="https://github.com/koala73/worldmonitor.git"
IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/app:mvp"

say() { printf '\n\033[1;36m▸ %s\033[0m\n' "$*"; }

say "Using project ${PROJECT_ID} in ${REGION}"
gcloud config set project "${PROJECT_ID}" --quiet

say "Enabling required APIs (Cloud Run, Cloud Build, Artifact Registry)"
gcloud services enable run.googleapis.com cloudbuild.googleapis.com \
  artifactregistry.googleapis.com --quiet

say "Ensuring Artifact Registry repo '${REPO}' exists"
gcloud artifacts repositories describe "${REPO}" --location "${REGION}" --quiet 2>/dev/null ||
  gcloud artifacts repositories create "${REPO}" --location "${REGION}" \
    --repository-format docker --description "Universe Monitor images" --quiet

say "Fetching upstream app source (koala73/worldmonitor)"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT
git clone --depth 1 "${UPSTREAM}" "${WORKDIR}/app"

say "Building the app image with Cloud Build (this is the slow step, ~5-10 min)"
gcloud builds submit "${WORKDIR}/app" --tag "${IMAGE}" --quiet

say "Collecting optional feature env vars"
ENV_VARS=""
for var in UPSTASH_REDIS_REST_URL UPSTASH_REDIS_REST_TOKEN GROQ_API_KEY \
           OPENROUTER_API_KEY FINNHUB_API_KEY FRED_API_KEY EIA_API_KEY \
           NASA_FIRMS_API_KEY ACLED_EMAIL ACLED_PASSWORD AVIATIONSTACK_API \
           AISSTREAM_API_KEY WORLDMONITOR_VALID_KEYS; do
  val="${!var:-}"
  if [ -n "${val}" ]; then
    ENV_VARS="${ENV_VARS:+${ENV_VARS},}${var}=${val}"
    echo "  + ${var}"
  fi
done
[ -n "${ENV_VARS}" ] || echo "  (none set — dashboard will run on public feeds only)"

say "Deploying to Cloud Run (public)"
gcloud run deploy "${SERVICE}" \
  --image "${IMAGE}" \
  --region "${REGION}" \
  --allow-unauthenticated \
  --port 3000 \
  --memory 1Gi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 3 \
  ${ENV_VARS:+--set-env-vars "${ENV_VARS}"} \
  --quiet

URL="$(gcloud run services describe "${SERVICE}" --region "${REGION}" --format 'value(status.url)')"

say "Done — your dashboard is live and shareable:"
echo
echo "    ${URL}"
echo
echo "Share that URL directly (public HTTPS, Google-managed cert)."
echo "Next steps (optional):"
echo "  • Custom domain (app.aihumane.in): full stack via gcp/terraform/ (Phase 14),"
echo "    or quick map: gcloud beta run domain-mappings create --service ${SERVICE} \\"
echo "        --domain app.aihumane.in --region ${REGION}"
echo "  • Restrict access instead of public: remove --allow-unauthenticated and"
echo "    front with Identity-Aware Proxy (see docs/roadmap.md Phase 14/15)."
echo "  • Production tier (LB + Cloud Armor + SQL + workers): cd gcp/terraform &&"
echo "    terraform init && terraform apply (see gcp/README.md)."
