variable "project" {}
variable "project_id" {}
variable "db_pw" {
  type      = string
  sensitive = true
}
variable "region" {}
variable "node_type" {}