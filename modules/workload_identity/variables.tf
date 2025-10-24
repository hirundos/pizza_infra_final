variable "project_id" {}
variable "roles" {
  default = ["roles/iam.workloadIdentityUser"]
}
variable "namespace" {
  default = "default"
}
variable "gsa_account_id" {
  default = "my-gsa"
}
variable "ksa_name" {
  default = "my-ksa"
}
variable "bind_wl_role" {}
variable "gsa_display_nm" {
  default = "Workload Identity GSA"
}