terraform {
  backend "s3" {
    bucket = "hayley-t101study-tfstate"
    key    = "stg/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}