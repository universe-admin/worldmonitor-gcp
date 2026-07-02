# Phase 1 — enable the GCP APIs the platform depends on.
# disable_on_destroy = false so `terraform destroy` of the stack does not yank
# APIs that other things in the project might use.

locals {
  enabled_apis = [
    "compute.googleapis.com",           # Compute Engine / networking / LB
    "run.googleapis.com",               # Cloud Run
    "artifactregistry.googleapis.com",  # Artifact Registry
    "cloudbuild.googleapis.com",        # Cloud Build
    "sqladmin.googleapis.com",          # Cloud SQL
    "secretmanager.googleapis.com",     # Secret Manager
    "storage.googleapis.com",           # Cloud Storage
    "dns.googleapis.com",               # Cloud DNS
    "logging.googleapis.com",           # Cloud Logging
    "monitoring.googleapis.com",        # Cloud Monitoring
    "iap.googleapis.com",               # Identity-Aware Proxy
    "aiplatform.googleapis.com",        # Vertex AI (optional)
    "bigquery.googleapis.com",          # BigQuery
    "pubsub.googleapis.com",            # Pub/Sub
    "cloudscheduler.googleapis.com",    # Cloud Scheduler
    "redis.googleapis.com",             # Memorystore for Redis
    "vpcaccess.googleapis.com",         # Serverless VPC Access connector
    "servicenetworking.googleapis.com", # Private services access (Cloud SQL PSA)
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(local.enabled_apis)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
