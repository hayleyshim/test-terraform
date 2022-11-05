# define GCP project name
variable "gcp_project" {
  type        = string
  description = "GCP project name"
  default     = "[project id]"
}

# define GCP region
variable "gcp_region" {
  type        = string
  description = "GCP region"
  default     = "asia-northeast3"
}

variable "bucket-name" {
  type        = string
  description = "The name of the Google Storage Bucket to create"
  default     = "tf-bucket"
}

variable "storage-class" {
  type        = string
  description = "The storage class of the Storage Bucket to create"
  default     = "REGIONAL"
}

variable "credentials" {
    default = "../../credentials/key.json"
}