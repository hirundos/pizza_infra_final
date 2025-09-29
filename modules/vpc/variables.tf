variable "vpc_nm" {}
variable "snet_nm" {}
variable "vpc_ip_range_nm" {}
variable "nat_nm" {}
variable "router_nm" {}
variable "region" {}
variable "node_range" {}
variable "gke_pods_range" {}
variable "gke_services_range" {}
variable "snet_range" {}
variable "cloudsql_port" {
  default = "5432"
}