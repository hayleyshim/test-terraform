resource "google_compute_disk" "disk_vm_os_1" {
  project = var.project_id
  name    = "disk-vm-os-1"
  zone    = "asia-northeast3-a"
  type    = "pd-balanced"
  image   = "centos-7-v20220621"
  size    = 50
}

resource "google_compute_disk" "disk_vm_data_1" {
  project = var.project_id
  name    = "disk-vm-data-1"
  zone    = "asia-northeast3-a"
  type    = "pd-balanced"
  size    = 150
}