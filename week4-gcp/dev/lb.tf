#######################
# DEV Unity LB
#######################

resource "google_compute_health_check" "hc_vm_1" {
  name = "hc-vm-1"

  healthy_threshold = 2
  unhealthy_threshold = 3
  timeout_sec = 10
  check_interval_sec = 10

  log_config {
    enable = true
  }

  http_health_check {
    request_path = "/"
    port = 80
  }

  //network     = "${var.project_id}-vpc"
  //subnet  = "${var.project_id}-subnet"
}

resource "google_compute_forwarding_rule" "nlb_hc_vm_1" {
  name = "nlb-hc-vm-1"

  //ip_address = google_compute_address.priip_an3_dev_int_demo_lb_1.address
  region = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service = google_compute_region_backend_service.nlb_hc_vm_1.id
  ports = ["3000", "9000"]
  ip_protocol = "TCP"
  
  network               = google_compute_network.vpc.id
  subnetwork            = google_compute_subnetwork.subnet.id
}

resource "google_compute_region_backend_service" "nlb_hc_vm_1" {
  name = "nlb-hc-vm-1"

  region = var.region
  protocol = "TCP"
  load_balancing_scheme = "INTERNAL"

  timeout_sec = 10
  health_checks = [google_compute_health_check.hc_vm_1.id]

  backend {
    group = google_compute_instance_group.umig_hc_vm_1.id
  }
}

resource "google_compute_instance_group" "umig_hc_vm_1" {
  name = "umig-hc-vm-unity-1"
  zone = "${var.region}-a"

  instances = [
    google_compute_instance.vm.id
  ]

  network     = "${var.project_id}-vpc"
  //subnetwork  = "${var.project_id}-subnet"
}