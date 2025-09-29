
resource "google_compute_network" "pz_vpc" {
  name                    = var.vpc_nm
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "main_subnet" {
  name          = var.snet_nm
  ip_cidr_range = var.snet_range
  region        = var.region
  network       = google_compute_network.pz_vpc.id

  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = var.gke_pods_range
  }

  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = var.gke_services_range
  }

}

resource "google_compute_global_address" "private_ip_address" {
  name          = var.vpc_ip_range_nm
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  address       = "192.168.0.0"
  network       = google_compute_network.pz_vpc.id
}


resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.pz_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_compute_global_address.private_ip_address]

  lifecycle {
    prevent_destroy = true
  }
}


# 1. Cloud Router 생성
resource "google_compute_router" "main_router" {
  name    = var.router_nm
  network = google_compute_network.pz_vpc.name
  region  = var.region
}

# 2. NAT Gateway 생성
resource "google_compute_router_nat" "nat_gateway" {
  name                               = var.nat_nm
  router                             = google_compute_router.main_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  enable_endpoint_independent_mapping = true

  log_config {
    enable = true
    filter = "ALL"
  }
}


