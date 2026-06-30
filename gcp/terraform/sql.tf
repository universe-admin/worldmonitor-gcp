# Phase 6 — Database. Cloud SQL for PostgreSQL on a private IP, automated
# backups, optional HA. Databases per the plan: users, organizations, events,
# knowledge_graph, audit_logs, tasks, documents.

resource "google_sql_database_instance" "postgres" {
  name             = "universe-monitor-pg"
  database_version = "POSTGRES_16"
  region           = var.region

  # Guard against accidental `terraform destroy` of the production database.
  deletion_protection = true

  depends_on = [google_service_networking_connection.psa]

  settings {
    tier              = var.db_tier
    availability_type = var.db_high_availability ? "REGIONAL" : "ZONAL"
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    user_labels       = var.labels

    ip_configuration {
      ipv4_enabled    = false # private IP only (Phase 6 / Phase 15)
      private_network = google_compute_network.vpc.id
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "03:00"
      transaction_log_retention_days = 7
    }

    insights_config {
      query_insights_enabled = true
    }
  }
}

locals {
  databases = [
    "users",
    "organizations",
    "events",
    "knowledge_graph",
    "audit_logs",
    "tasks",
    "documents",
  ]
}

resource "google_sql_database" "dbs" {
  for_each = toset(local.databases)

  name     = each.value
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "app" {
  name     = "uvm_app"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db.result
}
