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
  description = "Concord Environment"
  type        = string
}

variable "subnets" {
  description = "Comma seperated list of subnet ids"
  type        = list(string)
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
  type        = list(string)
}

variable "health_check_path" {
  description = "Path to check if the service is healthy"
  type        = string
}

variable "tags" {
  type = map(any)
}
