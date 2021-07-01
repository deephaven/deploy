# Basic Network Firewall Rules | network-firewall.tf

# Allow 10000 for deephaven
resource "google_compute_firewall" "allow-http" {
  name    = "${var.app_name}-${var.app_environment}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["10000"]
  }
  target_tags = ["deephaven"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.app_name}-${var.app_environment}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
