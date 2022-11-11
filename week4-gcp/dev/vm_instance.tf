#######################
# DEV Unity VM
#######################

resource "google_compute_instance" "vm" {
  name         = "vm"
  machine_type = "f1-micro"
  zone         = "asia-northeast3-a"

  # deletion_protection = true
  # allow_stopping_for_update = true

  tags = ["foo", "bar"]

  labels = {
    "name"    = "f1-micro",
    "hiware"  = "dev"
  }

  boot_disk {
    auto_delete = false
    device_name = google_compute_disk.disk_vm_os_1.name
    source      = google_compute_disk.disk_vm_os_1.name
  }

  attached_disk {
    device_name = google_compute_disk.disk_vm_data_1.name
    source      = google_compute_disk.disk_vm_data_1.name
  }

  network_interface {
    network     = "${var.project_id}-vpc"
    subnetwork  = "${var.project_id}-subnet"
  }
  /*
  service_account {
    email = var.svcacc_email
    scopes = var.svcacc_scopes
  }*/
}