variable "project_id" {
  description = "project id"
  default     = "[project id]"
}

variable "region" {
  description = "region"
  default     = "asia-northeast3"
}


variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "gke_machine_type" {
  default     = "e2-medium"
  description = "machine type of gke nodes"
}