terraform {
  backend "s3" {
    bucket = "hayley-t101study-tfstate"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}