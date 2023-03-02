# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters, they should be provided by the parent terragrunt config
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of the ECS Service"
  type        = string
}

variable "custom_actions" {
  type    = list(string)
  default = []
}

variable "iam_policies" {
  type = map(object({
    Actions   = list(string),
    Effect    = string,
    Resources = list(string)
  }))
}

variable "tags" {
  type = map(any)
}
