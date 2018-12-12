output "subnetwork_name" {
  value = "${google_compute_subnetwork.default.name}"
}

output "container_account_key" {
  value = "${base64decode(google_service_account_key.default.private_key)}"
}
