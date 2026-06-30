# Growth tier — Memorystore for Redis (managed RESP). The app expects an
# Upstash-style REST endpoint, so the redis-rest Cloud Run service (run.tf)
# bridges Memorystore <-> the REST contract.

resource "google_redis_instance" "cache" {
  count = var.deploy_redis ? 1 : 0

  name               = "universe-monitor-redis"
  tier               = "BASIC"
  memory_size_gb     = var.redis_memory_gb
  region             = var.region
  authorized_network = google_compute_network.vpc.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  redis_version      = "REDIS_7_0"
  auth_enabled       = true
  labels             = var.labels

  depends_on = [
    google_project_service.enabled,
    google_service_networking_connection.psa,
  ]
}
