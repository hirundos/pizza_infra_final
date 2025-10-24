variable "region" {
    default = "us-central1"
}
variable "project_id" {}
variable "sql_nm" {
    default = "my-sql-instance"
}
variable "db_size" {
    default = "db-f1-micro"
}
variable "vpc_connection" {}
variable "vpc" {}