# Useful values after apply.

output "load_balancer_ip" {
  description = "Static IP to point DNS at (Phase 14)."
  value       = google_compute_global_address.lb_ip.address
}

output "dns_name_servers" {
  description = "Set these as your registrar's nameservers for the domain."
  value       = var.manage_dns ? google_dns_managed_zone.zone[0].name_servers : []
}

output "artifact_registry" {
  description = "Docker repo path for image pushes (Phase 4)."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}"
}

output "sql_connection_name" {
  description = "Cloud SQL instance connection name (Phase 6)."
  value       = google_sql_database_instance.postgres.connection_name
}

output "sql_private_ip" {
  description = "Private IP of the Postgres instance."
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "redis_host" {
  description = "Memorystore host (empty when deploy_redis = false)."
  value       = var.deploy_redis ? google_redis_instance.cache[0].host : ""
}

output "cloud_run_services" {
  description = "Deployed Cloud Run service URLs."
  value       = { for k, s in google_cloud_run_v2_service.app : k => s.uri }
}

output "service_accounts" {
  description = "Runtime service account emails (Phase 2)."
  value = {
    frontend    = google_service_account.frontend.email
    backend     = google_service_account.backend.email
    ai_agent    = google_service_account.ai_agent.email
    cloud_build = google_service_account.cloud_build.email
    terraform   = google_service_account.terraform.email
  }
}
