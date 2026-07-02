# Phase 9 — Secrets. Create the Secret Manager *containers* here; the secret
# *values* are added out-of-band (gcloud / console / CI), never committed.
#
#   echo -n "s3cr3t" | gcloud secrets versions add db-password --data-file=-
#
# The DB password is the one secret we generate, so Cloud SQL and the app agree.

locals {
  # Credentials the platform expects (Phase 9 list + the feed keys from .env.example).
  managed_secrets = [
    "anthropic-api-key",
    "openai-api-key",
    "github-token",
    "jwt-signing-key",
    "oauth-client-id",
    "oauth-client-secret",
    "relay-shared-secret",
    "redis-token",
    "worldmonitor-valid-keys",
    # Optional data-feed keys (each unlocks a layer; app runs without them).
    "finnhub-api-key",
    "fred-api-key",
    "eia-api-key",
    "nasa-firms-api-key",
    "acled-email",
    "acled-password",
    "aviationstack-api",
    "aisstream-api-key",
    "cloudflare-api-token",
  ]
}

resource "google_secret_manager_secret" "managed" {
  for_each = toset(local.managed_secrets)

  secret_id = each.value
  labels    = var.labels

  replication {
    auto {}
  }

  depends_on = [google_project_service.enabled]
}

# DB password: generated and stored so SQL + app share one source of truth.
resource "random_password" "db" {
  length  = 32
  special = false
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password"
  labels    = var.labels

  replication {
    auto {}
  }

  depends_on = [google_project_service.enabled]
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db.result
}

# Grant the backend + AI SAs access to read the secrets (project-level grant in
# iam.tf already covers secretAccessor; nothing per-secret needed here).
