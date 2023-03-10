# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters, they should be provided by the parent terragrunt config
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of your stack"
  type        = string
}

variable "vpc_id" {
  description = "The VPC in which to deploy the service"
  type        = string
}

variable "env" {
  description = "Environment Name"
  type        = string
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  type        = number
}

variable "tags" {
  type = map(any)
}
