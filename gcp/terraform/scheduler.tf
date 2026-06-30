# Cloud Scheduler — periodic jobs that drive the Phase 16 ingestion pipeline by
# publishing to Pub/Sub (Connectors -> Pub/Sub -> Workers -> ...).

# Kick the OSINT ingestion every 15 minutes.
resource "google_cloud_scheduler_job" "osint_poll" {
  name      = "uvm-osint-poll"
  schedule  = "*/15 * * * *"
  time_zone = "Etc/UTC"
  region    = var.region

  pubsub_target {
    topic_name = google_pubsub_topic.topics["osint-feed"].id
    data       = base64encode(jsonencode({ trigger = "scheduled-poll" }))
  }

  depends_on = [google_project_service.enabled]
}

# Nightly document-processing sweep.
resource "google_cloud_scheduler_job" "doc_sweep" {
  name      = "uvm-doc-sweep"
  schedule  = "0 4 * * *"
  time_zone = "Etc/UTC"
  region    = var.region

  pubsub_target {
    topic_name = google_pubsub_topic.topics["document-processing"].id
    data       = base64encode(jsonencode({ trigger = "nightly-sweep" }))
  }

  depends_on = [google_project_service.enabled]
}
