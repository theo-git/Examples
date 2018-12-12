// Configure the Google Cloud APIs (choose which to enable)
resource "google_project_services" "default" {
  project = "${var.project_name}"

  services = [
    "bigquery-json.googleapis.com",        # Google really wants this enabled
    "bigtable.googleapis.com",
    "cloudapis.googleapis.com",
    "clouddebugger.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "dataflow.googleapis.com",
    "datastore.googleapis.com",            # Google really wants this enabled
    "deploymentmanager.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",               # Google really wants this enabled
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "servicemanagement.googleapis.com",
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
  ]
}

resource "google_compute_network" "default" {
  name                    = "${var.project_name}-net"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.project_name}-${var.region}"
  ip_cidr_range = "${var.cidr}"
  network       = "${google_compute_network.default.name}"
  region        = "${var.region}"
}

resource "google_compute_firewall" "allow-office-in" {
  name    = "allow-office-in"
  network = "${google_compute_network.default.name}"

  source_ranges = ["199.231.241.22/32"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
}

resource "google_compute_firewall" "allow-openvpn-tcp-and-udp" {
  name    = "allow-openvpn-tcp-and-udp"
  network = "${google_compute_network.default.name}"

  source_ranges = ["10.0.112.0/22"]
  priority      = "900"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "allow-ping-internal-network" {
  name    = "allow-ping-internal-network"
  network = "${google_compute_network.default.name}"

  source_ranges = ["10.0.0.0/8"]
  priority      = "900"

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  network = "${google_compute_network.default.name}"

  source_ranges = ["${var.cidr}"]
  priority      = "900"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
}

resource "google_compute_firewall" "allow-prometheus" {
  name    = "allow-prometheus"
  network = "${google_compute_network.default.name}"

  source_ranges = ["10.1.24.0/21"]
  priority      = "900"

  allow {
    protocol = "tcp"
    ports    = ["3020", "9090"]
  }
}

resource "google_compute_firewall" "allow-prov-chf-web" {
  name        = "allow-prov-chf-web"
  network     = "${google_compute_network.default.name}"
  description = "Allow providence IP space to hit CHF web box"

  source_ranges = [
    "170.173.0.0/16",
    "204.80.136.0/24",
    "207.225.232.0/24",
    "198.22.194.0/24",
    "69.238.162.0/24",
    "216.0.0.0/24",
  ]

  target_tags = ["chf-web"]
  priority    = "800"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "allow-services-net-in" {
  name    = "allow-services-net-in"
  network = "${google_compute_network.default.name}"

  source_ranges = ["10.1.24.0/21"]
  priority      = "900"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "allow-stackdriver-uptime-checks" {
  name    = "allow-stackdriver-uptime-checks"
  network = "${google_compute_network.default.name}"

  source_ranges = [
    "104.155.110.139",
    "104.155.77.122",
    "146.148.119.250",
    "146.148.41.163",
    "146.148.59.114",
    "23.251.144.62",
    "35.186.144.97",
    "35.186.164.184",
    "35.187.242.246",
    "35.188.230.101",
    "35.197.117.125",
    "35.198.18.224",
    "35.198.221.49",
    "35.199.157.7",
    "35.199.27.30",
    "35.199.66.47",
    "35.199.67.79",
    "35.203.157.42",
  ]

  target_tags = ["chf-web"]
  priority    = "900"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "no-ip-to-natgw" {
  name    = "no-ip-to-natgw"
  network = "${google_compute_network.default.name}"

  source_tags = ["no-ip"]
  target_tags = ["nat"]
  priority    = "900"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
}

resource "google_compute_route" "no-ip-to-natgw" {
  name       = "no-ip-to-natgw"
  network    = "${google_compute_network.default.name}"
  dest_range = "0.0.0.0/0"
  priority   = 800

  next_hop_instance      = "${google_compute_instance.nat-gateway.name}"
  next_hop_instance_zone = "${google_compute_instance.nat-gateway.zone}"
  tags                   = ["no-ip"]
}

resource "google_compute_instance" "nat-gateway" {
  name           = "${var.project_name}-nat-gateway"
  machine_type   = "custom-2-2048"
  zone           = "us-central1-c"
  tags           = ["nat"]
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20170328"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"

    access_config {
      // Ephemeral external IP
    }
  }

  metadata_startup_script = "apt-get update; sysctl -w net.ipv4.ip_forward=1; iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE; sed -i -e '/^DEFAULT_FORWARD_POLICY=\"DROP\"/{ s/.*/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/ }' /etc/default/ufw"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_service_account" "default" {
  account_id   = "${var.account_id}"
  project      = "${var.project_name}"
  display_name = "${var.account_id}"
}

resource "google_service_account_key" "default" {
  service_account_id = "${google_service_account.default.name}"
}

resource "google_project_iam_member" "default" {
  project = "${var.project_name}"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "container" {
  project = "${var.project_name}"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "containerObject" {
  project = "${var.project_name}"
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}
