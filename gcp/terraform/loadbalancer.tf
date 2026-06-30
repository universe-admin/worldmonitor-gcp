# Phase 14 (Networking) + Phase 15 (Security).
# Global external HTTPS load balancer -> Cloud Armor -> serverless NEGs (Cloud Run),
# a Google-managed TLS cert for every host, HTTP->HTTPS redirect, and a reserved
# static anycast IP for DNS to point at.

# ── Reserved static external IP ─────────────────────────────────────────────
resource "google_compute_global_address" "lb_ip" {
  name = "uvm-lb-ip"
}

# ── Serverless NEGs (one per public Cloud Run service) ──────────────────────
resource "google_compute_region_network_endpoint_group" "neg" {
  for_each = local.run_services

  name                  = "uvm-neg-${each.key}"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloud_run_v2_service.app[each.key].name
  }
}

# ── Cloud Armor (WAF) ───────────────────────────────────────────────────────
resource "google_compute_security_policy" "armor" {
  name = "uvm-armor"

  # Default allow; layer rules below.
  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default allow"
  }

  # Block common web attacks via preconfigured WAF rule sets.
  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-v33-stable') || evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }
    description = "OWASP XSS + SQLi"
  }

  # Per-IP rate limit.
  rule {
    action   = "rate_based_ban"
    priority = 1100
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      enforce_on_key = "IP"
      rate_limit_threshold {
        count        = 600
        interval_sec = 60
      }
      ban_duration_sec = 120
    }
    description = "rate limit 600 req/min/IP"
  }
}

# ── Backend services (one per NEG), all behind Cloud Armor ──────────────────
resource "google_compute_backend_service" "backend" {
  for_each = local.run_services

  name                  = "uvm-be-${each.key}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  security_policy       = google_compute_security_policy.armor.id
  enable_cdn            = each.key == "frontend"

  backend {
    group = google_compute_region_network_endpoint_group.neg[each.key].id
  }

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

# ── URL map: route each host to its backend ─────────────────────────────────
resource "google_compute_url_map" "https" {
  name            = "uvm-urlmap"
  default_service = google_compute_backend_service.backend["frontend"].id

  dynamic "host_rule" {
    for_each = var.subdomains
    content {
      hosts        = [host_rule.key]
      path_matcher = replace(host_rule.key, ".", "-")
    }
  }

  dynamic "path_matcher" {
    for_each = var.subdomains
    content {
      name            = replace(path_matcher.key, ".", "-")
      default_service = google_compute_backend_service.backend[path_matcher.value].id
    }
  }
}

# ── Google-managed TLS cert covering every host ─────────────────────────────
resource "google_compute_managed_ssl_certificate" "cert" {
  name = "uvm-cert"

  managed {
    domains = keys(var.subdomains)
  }
}

resource "google_compute_target_https_proxy" "https" {
  name             = "uvm-https-proxy"
  url_map          = google_compute_url_map.https.id
  ssl_certificates = [google_compute_managed_ssl_certificate.cert.id]
}

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "uvm-https-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = "443"
  target                = google_compute_target_https_proxy.https.id
}

# ── HTTP -> HTTPS redirect ──────────────────────────────────────────────────
resource "google_compute_url_map" "http_redirect" {
  name = "uvm-http-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "http" {
  name    = "uvm-http-proxy"
  url_map = google_compute_url_map.http_redirect.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name                  = "uvm-http-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.http.id
}
