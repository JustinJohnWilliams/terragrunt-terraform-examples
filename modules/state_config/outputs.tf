output "s3_bucket_arn" {
  description = "The ARN of the s3 bucket that holds state"
  value       = aws_s3_bucket.bucket.arn
}

output "dynamo_table_name" {
  description = "The Name of the Dynamo DB Table for locks"
  value       = aws_dynamodb_table.terraform_locks.name
}
