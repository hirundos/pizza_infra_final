variable "vpc_nm" {
  default = "my-vpc"
}
variable "snet_nm" {
  default = "my-subnet"
}
variable "vpc_ip_range_nm" {
  default = "my-vpc-ip-range"
}
variable "nat_nm" {
  default = "my-nat-gateway"
}
variable "router_nm" {
  default = "my-router"
}
variable "region" {
  default = "us-central1"
}
variable "node_range" {
  default = "10.0.0.0/24"
}
variable "gke_pods_range" {
  default = "10.0.1.0/24"
}
variable "gke_services_range" {
  default = "10.0.2.0/24"
}
variable "snet_range" {
  default = "10.0.3.0/24"
}
variable "cloudsql_port" {
  default = "5432"
}