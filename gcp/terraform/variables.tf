# Input variables. Copy terraform.tfvars.example -> terraform.tfvars and edit.
# Defaults follow the cloud-native plan (project aihumane-prod, domain aihumane.in).

variable "project_id" {
  description = "GCP project id (Phase 1). The plan calls for a dedicated project."
  type        = string
  default     = "aihumane-prod"
}

variable "region" {
  description = "Primary region for regional resources (Cloud Run, SQL, Memorystore)."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default zone for zonal resources (e.g. an optional GCE/Ollama VM)."
  type        = string
  default     = "us-central1-a"
}

variable "domain" {
  description = "Apex domain pointed at the HTTPS load balancer (Phase 14)."
  type        = string
  default     = "aihumane.in"
}

variable "subdomains" {
  description = <<-EOT
    Host -> Cloud Run service map for the managed cert + LB URL map (Phase 14).
    Keys are fully-qualified hostnames; values are the Cloud Run service key in
    local.run_services. "app" fronts the SPA + API, "api" the same app image.
  EOT
  type        = map(string)
  default = {
    "aihumane.in"       = "frontend"
    "app.aihumane.in"   = "frontend"
    "api.aihumane.in"   = "backend"
    "docs.aihumane.in"  = "frontend"
    "admin.aihumane.in" = "auth"
  }
}

variable "manage_dns" {
  description = "Create a Cloud DNS managed zone for the domain (Phase 14)."
  type        = bool
  default     = true
}

# ---- Images (Phase 4 / 5). Built by Cloud Build into Artifact Registry. ----
variable "image_app" {
  description = "Container image for the worldmonitor app (frontend + api + MCP)."
  type        = string
  default     = "" # e.g. us-central1-docker.pkg.dev/aihumane-prod/universe-monitor/app:latest
}

variable "image_ais_relay" {
  description = "Container image for the AIS relay service."
  type        = string
  default     = ""
}

variable "image_redis_rest" {
  description = "Container image for the Upstash-compatible Redis REST proxy."
  type        = string
  default     = ""
}

variable "image_worker" {
  description = "Container image for the private AI worker (Phases 10 & 16)."
  type        = string
  default     = "" # built from workers/ by Cloud Build
}

variable "enable_ollama" {
  description = "Deploy the self-hosted Ollama (local-AI) Cloud Run service (Phase 10)."
  type        = bool
  default     = false
}

variable "image_ollama" {
  description = "Ollama container image (used when enable_ollama = true)."
  type        = string
  default     = "ollama/ollama:latest"
}

# ---- Data tier sizing (Phases 6 / Growth). ----
variable "db_tier" {
  description = "Cloud SQL machine tier (Phase 6). db-custom-1-3840 ~ MVP."
  type        = string
  default     = "db-custom-1-3840"
}

variable "db_high_availability" {
  description = "Cloud SQL REGIONAL (HA) vs ZONAL. HA when traffic warrants it (Phase 6)."
  type        = bool
  default     = false
}

variable "redis_memory_gb" {
  description = "Memorystore for Redis capacity in GB (Growth tier)."
  type        = number
  default     = 1
}

variable "deploy_redis" {
  description = "Provision Memorystore (Growth). MVP can run without managed Redis."
  type        = bool
  default     = true
}

# ---- Cost guardrails (Phase 5). ----
variable "min_instances" {
  description = "Cloud Run min instances for latency-sensitive services (e.g. MCP)."
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Cloud Run max instances (autoscaling ceiling)."
  type        = number
  default     = 4
}

variable "alert_email" {
  description = "Email for Cloud Monitoring alert notifications (Phase 12)."
  type        = string
  default     = ""
}

variable "labels" {
  description = "Labels applied to all resources that support them."
  type        = map(string)
  default = {
    app        = "universe-monitor"
    managed-by = "terraform"
    platform   = "aihumane"
  }
}
