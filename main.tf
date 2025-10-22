
#$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\Users\ay\Downloads\pz_project_writer.json"

provider "google" {
  credentials = file("C:/Users/ay/Downloads/pz_project_writer.json")
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "pz-buck-888"
    prefix = "terraform/state"
  }
}

data "google_container_cluster" "primary" {
  name       = "pz-gke"
  location   = var.region
  depends_on = [module.gke]
}

data "google_client_config" "default" {
  depends_on = [module.gke]
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes = {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region
  vpc_nm = "${local.name_prefix}-vpc"
  snet_nm = "${local.name_prefix}-snet"
  vpc_ip_range_nm = "${local.name_prefix}-vpc-ip-range"
  router_nm = "${local.name_prefix}-router"
  nat_nm = "${local.name_prefix}-nat"

  node_range = "10.10.0.0/16"
  snet_range = "10.10.0.0/24"
  gke_pods_range = "10.20.0.0/16"
  gke_services_range ="10.30.0.0/20"
}

module "rdb" {
  source = "./modules/rdb"
  region = var.region
  project_id = var.project_id
  sql_nm = "${local.name_prefix}-db"
  db_size = "db-f1-micro"
  vpc = module.vpc.vpc
  vpc_connection = module.vpc.vpc_connection
}

module "gke" {
  source         = "./modules/gke"
  gke_nm = "${local.name_prefix}-gke"
  node_nm = "${local.name_prefix}-node-pool"
  region = var.region
  vpc_connection = module.vpc.vpc_connection
  node_type = var.node_type
  pz_vpc = module.vpc.vpc
  pz_snet = module.vpc.snet
  project_id = var.project_id
}

module "workload_identity" {
  source         = "./modules/workload_identity"
  project_id     = var.project_id
  gsa_account_id = "${local.name_prefix}-gsa"
  ksa_name       = "${local.name_prefix}-ksa"
  namespace      = "default"
  roles          = "roles/storage.admin"
}
