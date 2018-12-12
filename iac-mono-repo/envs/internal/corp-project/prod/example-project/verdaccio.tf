terraform {
    backend "gcs" {
        bucket = "example-terraform"
        prefix = "example-customer"
    }
}

provider "helm" {
}

resource "helm_release" "verdaccio" {
    name      = "npm"
    chart     = "stable/verdaccio"
    namespace = "verdaccio"
}
