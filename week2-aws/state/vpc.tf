provider "aws" {
  region  = "ap-northeast-1"
}

resource "aws_vpc" "hayley-vpc" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "tf-state"
  }
}