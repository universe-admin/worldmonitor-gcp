# Phases 10 & 16 — private AI worker. A streaming-pull Pub/Sub consumer that turns
# OSINT into structured intelligence with Claude. Deployed as a Cloud Run service
# with min-instances = 1 (a streaming pull worker must stay warm) on internal
# ingress, reaching Cloud SQL + Memorystore over the VPC connector.
#
# Source: ../../workers/. Long-running AI workloads can later move to GKE/GCE
# (see docs/architecture.md); Cloud Run covers the starter consumer loop.

locals {
  worker_image = var.image_worker != "" ? var.image_worker : local.placeholder

  # Worker consumes the AI / OSINT / document topics' worker subscriptions.
  worker_subscriptions = join(",", [
    google_pubsub_subscription.worker["ai-jobs"].name,
    google_pubsub_subscription.worker["osint-feed"].name,
    google_pubsub_subscription.worker["document-processing"].name,
  ])
}

resource "google_cloud_run_v2_service" "worker" {
  name     = "uvm-ai-worker"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  labels   = var.labels

  template {
    service_account = google_service_account.ai_agent.email

    # Keep one instance warm for the streaming pull; scale up under backlog.
    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = local.worker_image

      resources {
        limits = {
          cpu    = "1"
          memory = "1Gi"
        }
      }

      env {
        name  = "GCP_PROJECT"
        value = var.project_id
      }
      env {
        name  = "SUBSCRIPTIONS"
        value = local.worker_subscriptions
      }
      env {
        name  = "RAW_BUCKET"
        value = google_storage_bucket.data["raw-data"].name
      }
      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.postgres.private_ip_address
      }
      env {
        name  = "DB_NAME"
        value = "knowledge_graph"
      }
      env {
        name  = "DB_USER"
        value = google_sql_user.app.name
      }

      # Secrets from Secret Manager — never baked into the image (Phase 9).
      dynamic "env" {
        for_each = {
          ANTHROPIC_API_KEY = "anthropic-api-key"
          DB_PASSWORD       = "db-password"
        }
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value
              version = "latest"
            }
          }
        }
      }
    }
  }

  depends_on = [
    google_secret_manager_secret.managed,
    google_secret_manager_secret.db_password,
    google_pubsub_subscription.worker,
  ]
}
