# Providers + shared locals.

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Project metadata (number is needed for some IAM member strings).
data "google_project" "this" {
  project_id = var.project_id
}

locals {
  # Cloud Run service catalogue (Phase 5). Each maps to one image + service account.
  # frontend/backend/websocket/auth all run the same app image; they differ only in
  # role/SA/ingress so the LB can route subdomains and scale them independently.
  run_services = {
    frontend = {
      image           = var.image_app
      service_account = google_service_account.frontend.email
      ingress         = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
      description     = "SPA + API (served from the worldmonitor image)"
    }
    backend = {
      image           = var.image_app
      service_account = google_service_account.backend.email
      ingress         = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
      description     = "API + 39-tool MCP server"
    }
    websocket = {
      image           = var.image_app
      service_account = google_service_account.backend.email
      ingress         = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
      description     = "Realtime/websocket endpoints"
    }
    auth = {
      image           = var.image_app
      service_account = google_service_account.backend.email
      ingress         = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
      description     = "Auth / admin surface (front this with IAP)"
    }
  }
}
