# Phase 14 — Cloud DNS. Managed zone for the apex domain plus A records for every
# host, all pointing at the load balancer's static IP. After apply, set your
# registrar's nameservers to the zone's name servers (see outputs).

resource "google_dns_managed_zone" "zone" {
  count = var.manage_dns ? 1 : 0

  name        = "uvm-zone"
  dns_name    = "${var.domain}."
  description = "Universe Monitor — ${var.domain}"
  labels      = var.labels

  depends_on = [google_project_service.enabled]
}

resource "google_dns_record_set" "hosts" {
  for_each = var.manage_dns ? var.subdomains : {}

  name         = endswith(each.key, ".") ? each.key : "${each.key}."
  managed_zone = google_dns_managed_zone.zone[0].name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.lb_ip.address]
}
