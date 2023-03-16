# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "The name of the github team"
}

variable "description" {
  type        = string
  default     = ""
  description = "A description of the team"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "parent_team_id" {
  type        = number
  description = "The ID of the parent team, if this is a nested team"
  default     = null
}

variable "privacy" {
  type        = string
  description = "The level of privacy for the team. Must be one of `secret` or `closed`"
  default     = "closed"

  validation {
    condition     = contains(["secret", "closed"], var.privacy)
    error_message = "Member role must be one of `secret` or `closed`"
  }
}

variable "maintainers" {
  description = "The maintainers of the team"
  type        = list(string)
  default     = []
}
