terraform {
  required_version = ">= 1.2.9"
}

provider "aws" {
  region              = var.region
  allowed_account_ids = ["${var.aws_account_id}"]
}

# Create the s3 bucket to store state in
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

# create the ACL for the bucket to be private
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

# enable versioning on the bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable server side encryption on the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_algorithm
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }
}
