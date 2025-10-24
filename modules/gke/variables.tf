variable "vpc_connection" {}
variable "region" {
  default = "us-central1"
}
variable "gke_nm" {
  default = "my-gke-cluster"
}
variable "node_type" {
  default = "e2-standard-4"
}
variable "node_nm" {
  default = "my-gke-node"
}
variable "min_node_count" {
  default = 1
}
variable "max_node_count" {
  default = 3
}

variable "pz_vpc" {}
variable "pz_snet" {}
variable "project_id" {}