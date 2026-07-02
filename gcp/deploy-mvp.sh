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
# Only the project id is mandatory. The dashboard runs on public feeds with no
# keys or config. To unlock an optional data/AI layer later, set an env var on
# the running service without redeploying, e.g.:
#   gcloud run services update worldmonitor --region <REGION> \
#       --update-env-vars GROQ_API_KEY=...,FINNHUB_API_KEY=...
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

say "Building the app image with Cloud Build (clones upstream server-side; ~5-10 min)"
# The clone happens inside Cloud Build (--no-source) so this works even where
# local git egress to github.com is restricted.
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT
cat > "${WORKDIR}/build.yaml" <<EOF
steps:
  - id: fetch-source
    name: gcr.io/cloud-builders/git
    args: ["clone", "--depth", "1", "${UPSTREAM}", "app"]
  # Instance branding: rewrite the upstream author's profile link to ours,
  # wherever it appears in the source, before building. No-op if absent.
  - id: patch-branding
    name: gcr.io/cloud-builders/git
    dir: app
    entrypoint: bash
    args:
      - -c
      - |
        matches=\$(grep -rl 'x\.com/eliehabib' . 2>/dev/null || true)
        if [ -n "\$matches" ]; then
          echo "\$matches" | xargs sed -i 's|https://x\.com/eliehabib|https://www.linkedin.com/in/shivashish-borah/|g'
          echo "patched files:"; echo "\$matches"
        else
          echo "no x.com/eliehabib occurrences found (nothing to patch)"
        fi
  - id: build
    name: gcr.io/cloud-builders/docker
    dir: app
    args: ["build", "-t", "${IMAGE}", "."]
images:
  - "${IMAGE}"
options:
  logging: CLOUD_LOGGING_ONLY
  machineType: E2_HIGHCPU_8
timeout: 1800s
EOF
gcloud builds submit --no-source --config "${WORKDIR}/build.yaml" --quiet

say "Deploying to Cloud Run (public)"
# The image serves on 8080 (nginx). No env vars — the dashboard runs on public
# feeds; add optional keys later with `gcloud run services update` (see header).
gcloud run deploy "${SERVICE}" \
  --image "${IMAGE}" \
  --region "${REGION}" \
  --allow-unauthenticated \
  --port 8080 \
  --memory 1Gi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 3 \
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
