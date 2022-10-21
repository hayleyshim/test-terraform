provider "google" {
  project     = "firm-protocol-366104"
  region      = "asia-northeast3"
}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id 
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  zone         = var.zone
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_firewall" "rules" {
  project     = var.project_id # Replace this with your project ID in quotes
  name        = "my-firewall-rule"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["my-network"]
  target_tags = ["web"]
}

