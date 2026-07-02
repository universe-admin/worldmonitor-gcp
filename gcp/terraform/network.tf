# Phase 1 (VPC) + Phase 14 (Networking).
# Custom-mode VPC with public/private/management subnets, a serverless VPC
# connector for Cloud Run -> private resources, Cloud NAT for egress, private
# services access for Cloud SQL, and baseline firewall rules.

resource "google_compute_network" "vpc" {
  name                    = "universe-monitor-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

# ── Subnets ──────────────────────────────────────────────────────────────────
resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = "10.10.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "private" {
  name                     = "private-subnet"
  ip_cidr_range            = "10.10.16.0/20"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true # private instances reach Google APIs without public IPs
}

resource "google_compute_subnetwork" "management" {
  name                     = "management-subnet"
  ip_cidr_range            = "10.10.32.0/20"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# ── Serverless VPC Access connector (Cloud Run -> Memorystore/SQL/internal) ──
resource "google_vpc_access_connector" "connector" {
  name          = "uvm-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.48.0/28"
  min_instances = 2
  max_instances = 3

  depends_on = [google_project_service.enabled]
}

# ── Cloud NAT so private workloads have outbound internet (OSINT feeds, model pulls) ──
resource "google_compute_router" "router" {
  name    = "uvm-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "uvm-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# ── Private Services Access — VPC peering range for Cloud SQL private IP (Phase 6) ──
resource "google_compute_global_address" "psa_range" {
  name          = "uvm-psa-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "psa" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_range.name]

  depends_on = [google_project_service.enabled]
}

# ── Firewall (Phase 15) ─────────────────────────────────────────────────────
# Allow internal traffic between subnets.
resource "google_compute_firewall" "allow_internal" {
  name      = "uvm-allow-internal"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.10.0.0/16"]
}

# Allow Google's health-check / LB ranges to reach backends.
resource "google_compute_firewall" "allow_health_checks" {
  name      = "uvm-allow-health-checks"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
  }

  # GCP health-check + LB source ranges.
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

# SSH only via IAP TCP-forwarding range — no broad 0.0.0.0/0 SSH (Phase 14).
resource "google_compute_firewall" "allow_iap_ssh" {
  name      = "uvm-allow-iap-ssh"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # IAP TCP forwarding
  target_tags   = ["iap-ssh"]
}
