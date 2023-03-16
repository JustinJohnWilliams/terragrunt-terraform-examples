# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "The name for the organization"
}

variable "billing_email" {
  type        = string
  description = "The billing email address for the organization"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "company" {
  type        = string
  description = "The company name for the organization"
  default     = null
}

variable "blog" {
  type        = string
  description = "The blog URL for the organization"
  default     = null
}

variable "email" {
  type        = string
  description = "The email address for the organization"
  default     = null
}

variable "twitter_username" {
  type        = string
  description = "The Twitter username for the organization"
  default     = null
}

variable "location" {
  type        = string
  description = "The location for the organization"
  default     = null
}

variable "description" {
  type        = string
  description = "The description for the organization"
  default     = null
}

variable "has_organization_projects" {
  type        = bool
  description = "Whether or not organization projects are enabled for the organization"
  default     = true
}

variable "has_repository_projects" {
  type        = bool
  description = "Whether or not repository projects are enabled for the organization"
  default     = true
}

variable "default_repository_permission" {
  type        = string
  description = "The default permission for organization members to create new repositories (can be one of read, write, admin, or none)"
  default     = "read"

  validation {
    condition     = contains(["read", "write", "admin", "none"], var.default_repository_permission)
    error_message = "Default repository permission must be one of `read`, `write`, `admin`, or `none`."
  }
}

variable "members_can_create_repositories" {
  type        = bool
  description = "Whether or not organization members can create new repositories"
  default     = true
}

variable "members_can_create_public_repositories" {
  type        = bool
  description = "Whether or not organization members can create new public repositories"
  default     = true
}

variable "members_can_create_private_repositories" {
  type        = bool
  description = "Whether or not organization members can create new private repositories"
  default     = true
}

variable "members_can_create_internal_repositories" {
  type        = bool
  description = "Whether or not organization members can create new internal repositories (For Enterprise Organizations only)"
  default     = null
}

variable "members_can_create_pages" {
  type        = bool
  description = "Whether or not organization members can create new pages"
  default     = true
}

variable "members_can_create_public_pages" {
  type        = bool
  description = "Whether or not organization members can create new public pages"
  default     = true
}

variable "members_can_create_private_pages" {
  type        = bool
  description = "Whether or not organization members can create new private pages"
  default     = true
}

variable "members_can_fork_private_repositories" {
  type        = bool
  description = "Whether or not organization members can fork private repositories"
  default     = false
}

variable "web_commit_signoff_required" {
  type        = bool
  description = "Whether or not commit signatures are required for commits to the organization"
  default     = true
}

variable "advanced_security_enabled_for_new_repositories" {
  type        = bool
  description = "Whether or not advanced security is enabled for new repositories"
  default     = true
}

variable "dependabot_alerts_enabled_for_new_repositories" {
  type        = bool
  description = "Whether or not dependabot alerts are enabled for new repositories"
  default     = false
}

variable "dependabot_security_updates_enabled_for_new_repositories" {
  type        = bool
  description = "Whether or not dependabot security updates are enabled for new repositories"
  default     = false
}

variable "dependency_graph_enabled_for_new_repositories" {
  type        = bool
  description = "Whether or not dependency graph is enabled for new repositories"
  default     = false
}

variable "secret_scanning_enabled_for_new_repositories" {
  type        = bool
  description = "Whether or not secret scanning is enabled for new repositories"
  default     = true
}

variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  type        = bool
  description = "Whether or not secret scanning push protection is enabled for new repositories"
  default     = true
}
