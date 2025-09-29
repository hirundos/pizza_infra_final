resource "google_container_cluster" "primary" {
  name     = var.gke_nm
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network             = var.pz_vpc.name
  subnetwork          = var.pz_snet.name
  deletion_protection = false

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range"
    services_secondary_range_name = "gke-services-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.50.0.0/28"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  release_channel {
    channel = "REGULAR"
  }

  depends_on = [
    var.vpc_connection
  ]

}

resource "google_container_node_pool" "primary_nodes" {
  name       = var.node_nm
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = var.node_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["gke-node"]

  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = false
    auto_upgrade = true
  }
}
