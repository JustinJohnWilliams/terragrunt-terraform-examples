# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  description = "The AWS region things are created in"
}

variable "aws_account_id" {
  description = "The AWS Account ID to deploy the resources to"
  type        = string
}

variable "env" {
  description = "Environment Name"
}

variable "default_tags" {
  type = map(any)
}

variable "name" {
  type = string
}

variable "vpc_network_address" {
  description = "the first two octets of the vpc (e.g. 10.10)"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "availability_zones" {
  description = "the availability zones to use for the VPC"
  type        = list(string)
}

variable "tags" {
  type    = map(any)
  default = {}
}
