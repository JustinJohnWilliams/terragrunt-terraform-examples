# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters, they should be provided by the parent terragrunt config
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of your IAM Role"
  type        = string
}

variable "custom_actions" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(any)
}
