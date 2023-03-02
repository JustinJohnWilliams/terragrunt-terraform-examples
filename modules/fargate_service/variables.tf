# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED APPLICATION SPECIFIC PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_id" {
  description = "The VPC in which to deploy the service"
  type        = string
}

variable "name" {
  description = "The name of your stack"
  type        = string
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 8000
}

variable "container_cpu" {
  description = "The number of cpu units used by the task. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for combinations"
  default     = 1024
}

variable "container_memory" {
  description = "The Amount (in MiB) of memory used by the task. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for combinations"
  default     = 2048
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "health_check_path" {
  description = "Path for the LB to perform health checks"
  type        = string
  default     = "/"
}

variable "ecr_max_images" {
  description = "The max number of images for ECR to keep"
  type        = number
  default     = 10
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters, they should be provided by the parent terragrunt config
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
  description = "Default tags should be passed in from root terragrunt module (e.g. env, account, region, etc)"
  type        = map(any)
}

variable "iam_policies" {
  description = "Map of the IAM Permissions the Fargate Tasks will need to access"
  type = map(object({
    Actions   = list(string),
    Effect    = string,
    Resources = list(string)
  }))
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type    = map(any)
  default = {}
}
