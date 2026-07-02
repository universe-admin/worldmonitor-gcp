# Phase 5 — Compute. Stateless services on Cloud Run. Long-running AI workers
# can move to GKE/GCE later; Cloud Run covers frontend/backend/websocket/auth
# plus the internal ais-relay and redis-rest support services.

locals {
  # Until Cloud Build pushes the first image, fall back to a hello placeholder so
  # `terraform apply` succeeds on initial bring-up; CI then swaps in the real image.
  placeholder = "gcr.io/cloudrun/hello"

  app_image        = var.image_app != "" ? var.image_app : local.placeholder
  ais_relay_image  = var.image_ais_relay != "" ? var.image_ais_relay : local.placeholder
  redis_rest_image = var.image_redis_rest != "" ? var.image_redis_rest : local.placeholder

  # Redis coordinates for services that need them (empty when deploy_redis = false).
  redis_host = var.deploy_redis ? google_redis_instance.cache[0].host : ""
  redis_port = var.deploy_redis ? tostring(google_redis_instance.cache[0].port) : ""
}

# ── Public-facing app services (frontend / backend / websocket / auth) ──────
resource "google_cloud_run_v2_service" "app" {
  for_each = local.run_services

  name        = "uvm-${each.key}"
  location    = var.region
  description = each.value.description
  ingress     = each.value.ingress
  labels      = var.labels

  template {
    service_account = each.value.service_account

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = local.app_image

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      env {
        name  = "SERVICE_ROLE"
        value = each.key
      }
      env {
        name  = "REDIS_HOST"
        value = local.redis_host
      }
      env {
        name  = "REDIS_PORT"
        value = local.redis_port
      }
      env {
        name  = "CLOUD_SQL_CONNECTION_NAME"
        value = google_sql_database_instance.postgres.connection_name
      }

      # Secrets are mounted from Secret Manager, never baked into the image (Phase 9).
      dynamic "env" {
        for_each = {
          RELAY_SHARED_SECRET     = "relay-shared-secret"
          REDIS_TOKEN             = "redis-token"
          WORLDMONITOR_VALID_KEYS = "worldmonitor-valid-keys"
          JWT_SIGNING_KEY         = "jwt-signing-key"
          DB_PASSWORD             = "db-password"
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
    google_project_service.enabled,
    google_secret_manager_secret.managed,
    google_secret_manager_secret.db_password,
  ]
}

# ── Internal support services (reached over the VPC, not public) ────────────
resource "google_cloud_run_v2_service" "ais_relay" {
  name     = "uvm-ais-relay"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  labels   = var.labels

  template {
    service_account = google_service_account.ai_agent.email

    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = local.ais_relay_image
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
      env {
        name = "RELAY_SHARED_SECRET"
        value_source {
          secret_key_ref {
            secret  = "relay-shared-secret"
            version = "latest"
          }
        }
      }
    }
  }

  depends_on = [google_secret_manager_secret.managed]
}

resource "google_cloud_run_v2_service" "redis_rest" {
  name     = "uvm-redis-rest"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  labels   = var.labels

  template {
    service_account = google_service_account.backend.email

    scaling {
      min_instance_count = var.deploy_redis ? 1 : 0
      max_instance_count = 2
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = local.redis_rest_image
      resources {
        limits = {
          cpu    = "1"
          memory = "256Mi"
        }
      }
      env {
        name  = "REDIS_HOST"
        value = local.redis_host
      }
      env {
        name  = "REDIS_PORT"
        value = local.redis_port
      }
      env {
        name = "REDIS_TOKEN"
        value_source {
          secret_key_ref {
            secret  = "redis-token"
            version = "latest"
          }
        }
      }
    }
  }

  depends_on = [google_secret_manager_secret.managed]
}

# ── Optional self-hosted Ollama (local AI, no per-call API keys) — Phase 10 ──
resource "google_cloud_run_v2_service" "ollama" {
  count = var.enable_ollama ? 1 : 0

  name     = "uvm-ollama"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  labels   = var.labels

  template {
    service_account = google_service_account.ai_agent.email

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = var.image_ollama
      resources {
        limits = {
          cpu    = "4"
          memory = "16Gi"
        }
      }
      ports {
        container_port = 11434
      }
    }
  }
}
