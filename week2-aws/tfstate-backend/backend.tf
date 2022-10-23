provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "hayleys3bucket" {
  bucket = "hayley-t101study-tfstate"
}

# 테라폼에서 DynamoDB 잠금을 사용하기 위해서는 LockID 라는 기본 키가 있는 테이블을 생성해야됨
resource "aws_dynamodb_table" "hayley-dynamodbtable" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "hayleys3bucket_versioning" {
  bucket = aws_s3_bucket.hayleys3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.hayleys3bucket.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.hayley-dynamodbtable.name
  description = "The name of the DynamoDB table"
}