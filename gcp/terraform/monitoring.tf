# Phase 12 — Monitoring. Email notification channel, an uptime check on the app,
# and alert policies for uptime failures and elevated Cloud Run 5xx latency.
# Error Reporting + Cloud Logging are on by default once the APIs are enabled.

resource "google_monitoring_notification_channel" "email" {
  count = var.alert_email != "" ? 1 : 0

  display_name = "Universe Monitor — email"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

# Uptime check against the public app host.
resource "google_monitoring_uptime_check_config" "app" {
  display_name = "uvm-app-uptime"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = "/"
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.domain
    }
  }
}

# Alert when the uptime check fails.
resource "google_monitoring_alert_policy" "uptime" {
  count = var.alert_email != "" ? 1 : 0

  display_name = "uvm-app-down"
  combiner     = "OR"

  conditions {
    display_name = "Uptime check failing"
    condition_threshold {
      filter          = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id = \"${google_monitoring_uptime_check_config.app.uptime_check_id}\""
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      duration        = "120s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email[0].id]
}

# Alert on elevated Cloud Run server-error (5xx) request rate.
resource "google_monitoring_alert_policy" "run_5xx" {
  count = var.alert_email != "" ? 1 : 0

  display_name = "uvm-run-5xx"
  combiner     = "OR"

  conditions {
    display_name = "Cloud Run 5xx rate elevated"
    condition_threshold {
      filter          = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\" AND metric.label.response_code_class = \"5xx\""
      comparison      = "COMPARISON_GT"
      threshold_value = 10
      duration        = "300s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email[0].id]
}
