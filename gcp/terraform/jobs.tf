# Cloud Run Job — one-shot seeders (run.sh equivalent) that load initial data
# into Redis/SQL after a deploy. Trigger manually or from CI:
#   gcloud run jobs execute uvm-seeders --region <region>

resource "google_cloud_run_v2_job" "seeders" {
  name     = "uvm-seeders"
  location = var.region
  labels   = var.labels

  template {
    template {
      service_account = google_service_account.backend.email
      max_retries     = 1

      vpc_access {
        connector = google_vpc_access_connector.connector.id
        egress    = "PRIVATE_RANGES_ONLY"
      }

      containers {
        image   = local.app_image
        command = ["/bin/sh", "-c"]
        args    = ["./scripts/run-seeders.sh"]

        env {
          name  = "REDIS_HOST"
          value = local.redis_host
        }
        env {
          name  = "REDIS_PORT"
          value = local.redis_port
        }
        dynamic "env" {
          for_each = {
            REDIS_TOKEN        = "redis-token"
            NASA_FIRMS_API_KEY = "nasa-firms-api-key"
            DB_PASSWORD        = "db-password"
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
  }

  depends_on = [google_secret_manager_secret.managed]
}
