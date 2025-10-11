variable "vpc_connection" {}
variable "region" {}
variable "gke_nm" {}
variable "node_type" {
  default = "e2-standard-4"
}
variable "node_nm" {}
variable "min_node_count" {
  default = 1
}
variable "max_node_count" {
  default = 3
}

variable "pz_vpc" {}
variable "pz_snet" {}