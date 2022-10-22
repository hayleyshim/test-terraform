variable "project_id" {
  description = "project_id"
  type        = string
  default     = "firm-protocol-366104"

}


variable "region" {
  description = "region"
  default     = "asia-northeast3"
}


variable "zone" { 
   type = string 
   default = "asia-northeast3-a" 
}

variable "gke_num_nodes" {
  default     = 3
  description = "number of gke nodes"
}

variable "gke_machine_type" {
  default     = "e2-medium"
  description = "machine type of gke nodes"
}