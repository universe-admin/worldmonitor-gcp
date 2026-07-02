# Phase 7 — Object Storage. One bucket per data class from the plan.
# Names are globally unique, so prefix with the project id.

locals {
  buckets = {
    raw-data  = { versioning = false, age_days = 30 } # transient OSINT pulls
    documents = { versioning = true, age_days = 0 }   # keep
    images    = { versioning = false, age_days = 0 }
    exports   = { versioning = false, age_days = 90 }
    backups   = { versioning = true, age_days = 180 }
  }
}

resource "google_storage_bucket" "data" {
  for_each = local.buckets

  name                        = "${var.project_id}-${each.key}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false
  labels                      = var.labels

  versioning {
    enabled = each.value.versioning
  }

  # Optional age-based lifecycle deletion for transient/rotating data.
  dynamic "lifecycle_rule" {
    for_each = each.value.age_days > 0 ? [each.value.age_days] : []
    content {
      action {
        type = "Delete"
      }
      condition {
        age = lifecycle_rule.value
      }
    }
  }

  depends_on = [google_project_service.enabled]
}
