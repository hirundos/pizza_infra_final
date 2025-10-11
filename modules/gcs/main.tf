resource "google_storage_bucket" "basic_bucket" {
  name          = var.bucket_nm
  location      = "US"
  storage_class = "STANDARD"

}
