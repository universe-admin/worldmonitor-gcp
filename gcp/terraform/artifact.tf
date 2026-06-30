# Phase 4 — Containerization. One Artifact Registry Docker repo for all images
# (app, ais-relay, redis-rest, ollama, workers).

resource "google_artifact_registry_repository" "images" {
  location      = var.region
  repository_id = "universe-monitor"
  description   = "Universe Monitor container images"
  format        = "DOCKER"
  labels        = var.labels

  depends_on = [google_project_service.enabled]
}

# Cloud Build pushes; runtime SAs pull.
resource "google_artifact_registry_repository_iam_member" "build_writer" {
  location   = google_artifact_registry_repository.images.location
  repository = google_artifact_registry_repository.images.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.cloud_build.email}"
}

resource "google_artifact_registry_repository_iam_member" "runtime_readers" {
  for_each = toset([
    google_service_account.frontend.email,
    google_service_account.backend.email,
    google_service_account.ai_agent.email,
  ])

  location   = google_artifact_registry_repository.images.location
  repository = google_artifact_registry_repository.images.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${each.value}"
}
