output "vpc_connection" {
  value = google_service_networking_connection.private_vpc_connection.id
}

output "vpc" {
  value = google_compute_network.pz_vpc
}