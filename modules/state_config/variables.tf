# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  description = "which aws region to use"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID to deploy the resources to"
  type        = string
}

variable "env" {
  description = "the environment name [dev, stage, prod]"
  type        = string
}

variable "bucket_name" {
  description = "the name of the s3 bucket to hold state"
  type        = string
}

variable "encryption_algorithm" {
  description = "The algorithm used for bucket encryption"
  type        = string
  default     = "AES256"
}

variable "table_name" {
  description = "the name of the dynamo table"
  type        = string
}

variable "hash_key" {
  description = "The hash key for the table"
  type        = string
}

variable "hash_key_type" {
  description = "The hash key attribute type (S: String, N: Number, B: Binary)"
  type        = string
}

variable "billing_mode" {
  description = "The billing mode for the table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}
