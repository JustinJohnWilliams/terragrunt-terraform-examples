# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters, they should be provided by the parent terragrunt config
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of your stack"
  type        = string
}

variable "env" {
  description = "Concord Environment"
  type        = string
}

variable "max_images" {
  description = "The max number of images to keep"
  type        = number
  default     = 10
}

variable "tags" {
  type = map(any)
}
