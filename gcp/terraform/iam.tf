# Phase 2 — Identity. One service account per workload, least-privilege roles.

# ── Service accounts ────────────────────────────────────────────────────────
resource "google_service_account" "frontend" {
  account_id   = "uvm-frontend"
  display_name = "Universe Monitor — Frontend"
}

resource "google_service_account" "backend" {
  account_id   = "uvm-backend"
  display_name = "Universe Monitor — Backend API / MCP"
}

resource "google_service_account" "ai_agent" {
  account_id   = "uvm-ai-agent"
  display_name = "Universe Monitor — AI agents / workers"
}

resource "google_service_account" "cloud_build" {
  account_id   = "uvm-cloud-build"
  display_name = "Universe Monitor — Cloud Build deployer"
}

resource "google_service_account" "terraform" {
  account_id   = "uvm-terraform"
  display_name = "Universe Monitor — Terraform"
}

# ── Role grants (minimum each workload needs) ───────────────────────────────
locals {
  # role -> service account email. Kept flat so intent is auditable.
  iam_bindings = {
    # Backend: reads its secrets, talks to SQL, publishes/consumes Pub/Sub, R/W storage.
    "roles/secretmanager.secretAccessor@backend" = { role = "roles/secretmanager.secretAccessor", member = google_service_account.backend.email }
    "roles/cloudsql.client@backend"              = { role = "roles/cloudsql.client", member = google_service_account.backend.email }
    "roles/pubsub.editor@backend"                = { role = "roles/pubsub.editor", member = google_service_account.backend.email }
    "roles/storage.objectAdmin@backend"          = { role = "roles/storage.objectAdmin", member = google_service_account.backend.email }
    "roles/redis.editor@backend"                 = { role = "roles/redis.editor", member = google_service_account.backend.email }

    # Frontend: only needs to read a couple of public-config secrets.
    "roles/secretmanager.secretAccessor@frontend" = { role = "roles/secretmanager.secretAccessor", member = google_service_account.frontend.email }

    # AI agents/workers: secrets, SQL, Pub/Sub, storage, Vertex AI, BigQuery.
    "roles/secretmanager.secretAccessor@ai" = { role = "roles/secretmanager.secretAccessor", member = google_service_account.ai_agent.email }
    "roles/cloudsql.client@ai"              = { role = "roles/cloudsql.client", member = google_service_account.ai_agent.email }
    "roles/pubsub.editor@ai"                = { role = "roles/pubsub.editor", member = google_service_account.ai_agent.email }
    "roles/storage.objectAdmin@ai"          = { role = "roles/storage.objectAdmin", member = google_service_account.ai_agent.email }
    "roles/aiplatform.user@ai"              = { role = "roles/aiplatform.user", member = google_service_account.ai_agent.email }
    "roles/bigquery.dataEditor@ai"          = { role = "roles/bigquery.dataEditor", member = google_service_account.ai_agent.email }

    # Cloud Build: build/push images and deploy Cloud Run as the runtime SAs.
    "roles/run.admin@build"                = { role = "roles/run.admin", member = google_service_account.cloud_build.email }
    "roles/artifactregistry.writer@build"  = { role = "roles/artifactregistry.writer", member = google_service_account.cloud_build.email }
    "roles/cloudbuild.builds.editor@build" = { role = "roles/cloudbuild.builds.editor", member = google_service_account.cloud_build.email }
    "roles/logging.logWriter@build"        = { role = "roles/logging.logWriter", member = google_service_account.cloud_build.email }
  }
}

resource "google_project_iam_member" "bindings" {
  for_each = local.iam_bindings

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.member}"
}

# Cloud Build must be able to impersonate the runtime SAs it deploys as.
resource "google_service_account_iam_member" "build_acts_as_runtime" {
  for_each = toset([
    google_service_account.frontend.email,
    google_service_account.backend.email,
    google_service_account.ai_agent.email,
  ])

  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.value}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.cloud_build.email}"
}
