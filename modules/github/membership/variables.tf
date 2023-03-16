# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "username" {
  type        = string
  description = "The user to add to the organization"
}

variable "organization_role" {
  type        = string
  description = "The role of the user within the organization. Must be one of member or admin. Defaults to member"
  default     = "member"

  validation {
    condition     = contains(["member", "admin"], var.organization_role)
    error_message = "Member role must be one of `member`, `admin`"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "teams" {
  type        = list(string)
  description = "The teams to add this user as a member to"
  default     = []
}
