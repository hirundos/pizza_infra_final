data "google_secret_manager_secret_version" "db_password" {
  secret  = "projects/${var.project_id}/secrets/db-password"
  version = "latest"
}

resource "google_sql_database_instance" "private_instance" {
  name             = var.sql_nm
  region           = var.region
  database_version = "POSTGRES_17"

  settings {
    tier    = var.db_size
    edition = "ENTERPRISE"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc.id
    }

    backup_configuration {
      enabled = false
    }

    deletion_protection_enabled = false
  }

  depends_on = [var.vpc_connection]
}

resource "google_sql_database" "petclinic" {
  name     = data.google_secret_manager_secret_version.db_name.secret_data
  instance = google_sql_database_instance.private_instance.name
}

resource "google_sql_user" "postgres_user" {
  name     = data.google_secret_manager_secret_version.db_user.secret_data
  instance = google_sql_database_instance.private_instance.name
  password = data.google_secret_manager_secret_version.db_password.secret_data
}