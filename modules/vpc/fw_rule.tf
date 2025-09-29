
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  network = google_compute_network.pz_vpc.name

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

  source_ranges = [var.node_range]
}

resource "google_compute_firewall" "gke_internal" {
  name    = "gke-internal-communication"
  network = google_compute_network.pz_vpc.name

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

  source_tags = ["gke-node"]
  target_tags = ["gke-node"]
}

resource "google_compute_firewall" "gke_master_to_nodes" {
  name    = "gke-master-to-nodes"
  network = google_compute_network.pz_vpc.name

  allow {
    protocol = "tcp"
    ports = [
      "10250", # kubelet API
      "443",   # webhook, metrics-server 등
    ]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "10.50.0.0/28"] # GKE 마스터 IP 대역
  target_tags   = ["gke-node"]
}


resource "google_compute_firewall" "gke-egress" {
  name    = "gke-egress"
  network = google_compute_network.pz_vpc.name

  direction = "EGRESS"

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke_lb_to_nodes" {
  name    = "gke-lb-to-nodes"
  network = google_compute_network.pz_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"] # GCP LB IP 대역
  target_tags   = ["gke-node"]
}

resource "google_compute_firewall" "allow_gke_to_cloudsql" {
  name    = "allow-gke-to-cloudsql"
  network = google_compute_network.pz_vpc.name

  allow {
    protocol = "tcp"
    ports    = [var.cloudsql_port]
  }

  source_ranges = [var.node_range]
}
