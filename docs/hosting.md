# Hosting the dashboard & sharing it

Two tiers, matching the cost progression in [`roadmap.md`](roadmap.md). Both end
with a shareable HTTPS URL; they differ in how much of the 17-phase plan they
stand up.

## Option A — MVP in ~10 minutes (shareable URL today)

One public Cloud Run service running the dashboard. No load balancer, no custom
domain, no database — the dashboard runs on public feeds (each optional API key
you export unlocks another data layer).

1. Open **[Google Cloud Shell](https://shell.cloud.google.com)** (browser-only,
   already authenticated as you — nothing to install).
2. Make sure you have a project with billing enabled (e.g. `aihumane-prod`).
3. Run:

   ```bash
   git clone -b claude/universe-monitor-hosting-77vdio \
       https://github.com/universe-admin/worldmonitor-gcp.git
   cd worldmonitor-gcp
   ./gcp/deploy-mvp.sh aihumane-prod
   ```

   The project id is the only required argument — the dashboard runs on public
   feeds with no keys. To unlock an optional layer afterwards, set an env var on
   the running service (no redeploy):

   ```bash
   gcloud run services update worldmonitor --region us-central1 \
       --update-env-vars GROQ_API_KEY=...,FINNHUB_API_KEY=...
   ```

   **Open the Pro-gated UI on a self-host.** The app's single premium gate
   (`hasPremiumAccess()` in `src/services/panel-gating.ts`) unlocks when
   `WORLDMONITOR_API_KEY` is present — this is the upstream project's own
   self-host switch. Setting it removes every "Upgrade to Pro" CTA, lock badge,
   and paywall overlay, and enables the premium features served by the app's own
   bundled `api/*` handlers (chat-analyst, briefs, MCP). Premium data that the
   upstream app fetches from `api.worldmonitor.app` (the authors' hosted
   backend — some Country Deep Dive / markets cards) renders unlocked but stays
   empty, since that data lives on infrastructure a self-host does not run.

   ```bash
   gcloud run services update worldmonitor --region us-central1 \
       --update-env-vars WORLDMONITOR_API_KEY=wm_$(openssl rand -hex 20)
   ```

4. The script prints the live URL when done:

   ```
   ▸ Done — your dashboard is live and shareable:
       https://worldmonitor-xxxxxxxxxx-uc.a.run.app
   ```

**Sharing:** that `*.run.app` URL is public HTTPS with a Google-managed
certificate — send it to anyone. To share under your own name instead, map a
domain:

```bash
gcloud beta run domain-mappings create --service worldmonitor \
    --domain app.aihumane.in --region us-central1
# then add the DNS records it prints at your registrar
```

**Private sharing:** if the dashboard shouldn't be world-readable, redeploy
without `--allow-unauthenticated` and grant viewers `roles/run.invoker`, or put
Identity-Aware Proxy in front (Phase 14/15 of the plan).

**Cost:** scale-to-zero Cloud Run — roughly free at demo traffic; single-digit
dollars/month with steady viewers.

## Option B — full production stack (the 17-phase plan)

Everything in [`gcp/terraform/`](../gcp/terraform/): HTTPS load balancer +
Cloud Armor + `aihumane.in` DNS + Cloud SQL/pgvector + Pub/Sub + the private AI
worker. From Cloud Shell or any machine with Terraform ≥ 1.5:

```bash
cd gcp/terraform
cp terraform.tfvars.example terraform.tfvars   # set project_id, domain
terraform init && terraform apply
# then: add secret values, run the first Cloud Build, point your registrar
# at `terraform output dns_name_servers`  (details: ../gcp/README.md)
```

The dashboard is then shared at **https://app.aihumane.in** (and the API at
`api.aihumane.in`), behind the WAF, with real TLS on your domain.

**Recommended sequence:** ship Option A now to get the shareable link, keep
Option B as the follow-up — the MVP service can be deleted afterwards
(`gcloud run services delete worldmonitor`), or kept as a staging copy.

## Why this isn't run from the automation session

Deploying needs authenticated `gcloud`/Terraform against your GCP project. The
Claude session that authored this repo has no valid GCP credential (and the
Terraform provider registry is blocked by its egress policy), so the deploy
runs from Cloud Shell / your machine. If you add a valid GCP service-account
credential to the session environment, the deploy can be driven from chat
instead.
