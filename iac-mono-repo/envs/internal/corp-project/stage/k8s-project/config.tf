terraform {
  backend "gcs" {
    bucket = "example-terraform"
    prefix = "example-customer"
  }
}

provider "google" {
  project = "${var.project_name}"
  region  = "${var.region}"
}

module "cluster-1" {
  source = "cluster-1"

  subnetwork_name = "${var.subnetwork_name}"

  project_labels = {
    "system"   = "${var.system}"
    "customer" = "${var.customer}"
    "env"      = "${var.environment_type}"
  }
}
