# Terraform + provider version pins.
# Phase 13 (CI/CD) / Phase 1 (Foundation): the IaC toolchain.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.20.0, < 7.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.20.0, < 7.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }

  # Remote state lives in a GCS bucket so the team shares one source of truth.
  # Create the bucket once (see gcp/README.md), then `terraform init` against it.
  # Left commented so `terraform init` works locally before the bucket exists.
  #
  # backend "gcs" {
  #   bucket = "aihumane-prod-tfstate"
  #   prefix = "universe-monitor"
  # }
}
