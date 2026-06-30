# Phase 8 — Messaging. Pub/Sub topics decouple ingestion, AI, and notifications.
# Phase 16 data pipeline: Connectors -> Pub/Sub -> Workers -> Storage -> AI -> SQL.

locals {
  topics = [
    "osint-feed",
    "ai-jobs",
    "notifications",
    "document-processing",
    "telemetry",
  ]
}

resource "google_pubsub_topic" "topics" {
  for_each = toset(local.topics)

  name   = each.value
  labels = var.labels

  depends_on = [google_project_service.enabled]
}

# A pull subscription per topic for the AI workers. Workers ack as they process;
# 7-day retention covers worker downtime.
resource "google_pubsub_subscription" "worker" {
  for_each = toset(local.topics)

  name                       = "${each.value}-workers"
  topic                      = google_pubsub_topic.topics[each.value].id
  ack_deadline_seconds       = 60
  message_retention_duration = "604800s" # 7 days
  retain_acked_messages      = false

  expiration_policy {
    ttl = "" # never expire
  }
}
