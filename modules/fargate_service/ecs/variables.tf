# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters, they should be provided by the parent terragrunt config
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of your stack"
  type        = string
}

variable "env" {
  description = "Environment Name"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 1024
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
  default     = 2048
}

variable "container_image" {
  description = "The name of the container image"
  type        = string
}

variable "container_port" {
  description = "The port exposed in the container"
  type        = number
}

variable "ecs_service_desired_count" {
  description = "The desired number of nodes running"
  type        = number
  default     = 3
}

variable "ecs_service_security_groups" {
  description = "List of security groups"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet ids"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "The ALB Target Group"
  type        = string
}

variable "execution_role_arn" {
  description = "The IAM Role Arn for the ECS Task Execution Role"
  type        = string
}

variable "task_role_arn" {
  description = "The IAM Role Arn for the Task itself. (Note: This should be specific to the service)"
  type        = string
}

variable "tags" {
  type = map(any)
}
