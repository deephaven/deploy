# Create Google Cloud VM | vm.tf

# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

data "google_compute_image" "deephaven-image" {
  name = "deephaven"
  # project = "himantej-development-test"
  # could also use family = "family-name"
}
# Create VM #1
resource "google_compute_instance" "vm_instance_public" {
  name         = var.app_name
  machine_type = "n2-standard-8"
  zone         = var.gcp_zone_1
  tags         = ["ssh", "deephaven"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.deephaven-image.self_link
    }
  }

  metadata = {
    authorization = "103900000016063005"
  }

  labels = {
    authorization = "103900000016063005"
  }

  # metadata_startup_script = "sudo cd /opt/deephaven-core; sudo nohup docker-compose up &; sleep 5"
  #metadata_startup_script = "sudo touch /opt/startup.sh; sudo echo 'cd /data; git clone https://git@github.com:deephaven/deephaven-core.git; cd deephaven-core; bash deephaven-core; docker-compose build; sudo echo 'docker-compose -f /opt/deephaven-core/docker-compose.yml' up >> /opt/startup.sh; sudo chmod 755 /opt/startup.sh; bash /opt/startup.sh "
  metadata_startup_script = "sudo touch /opt/startup.sh; sudo echo 'cd /opt; git clone https://git@github.com:deephaven/deephaven-core.git; cd deephaven-core; ./gradlew prepareCompose; docker-compose build; docker-compose -f /opt/deephaven-core/docker-compose.yml up' >> /opt/startup.sh; sudo chmod 755 /opt/startup.sh; bash /opt/startup.sh "

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name
    access_config {}
  }
}
