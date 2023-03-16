# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "repository_id" {
  description = "The ID of the repository in which the branch protection rule will be created"
  type        = string
}

variable "pattern" {
  description = "The pattern identifying branches to which the proection rule will apply"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "enforce_admins" {
  description = "Setting this to true enforces status checks for repository administrators. In general this should be false to allow admins and service accounts to reconcile branches after a release without creating trailing merge commits -- branches would never be current with one another."
  type        = bool
  default     = true
}

variable "require_signed_commits" {
  description = "Requires all commits in the branch to be signed with GPG."
  type        = bool
  default     = true
}

variable "push_restrictions" {
  description = "A list of actor IDs that are explicitly permitted to push to the branch. Admins have this capability if `enforce_admins` is false."
  type        = list(string)
  default     = []
}

variable "allows_deletions" {
  description = "Setting this to `true` allows the branch to be deleted."
  type        = bool
  default     = false
}

variable "blocks_creations" {
  description = "Setting this to `true` will prevent creation of the branch."
  type        = bool
  default     = false
}

variable "allows_force_pushes" {
  description = "Setting this to `true` allows the branch to accept force pushes."
  type        = bool
  default     = true
}

variable "lock_branch" {
  description = "Setting this to `true` will make the branch read-only and prevent any pushes to it."
  type        = bool
  default     = false
}

variable "require_linear_history" {
  description = "Setting this to `true` enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch."
  type        = bool
  default     = false
}

variable "require_conversation_resolution" {
  description = "Setting this to `true` requires all conversations on code must be resolved before a pull request can be merged."
  type        = bool
  default     = true
}

variable "strict" {
  description = "Setting this to true enforces that a branch be current with the base branch before merging."
  type        = bool
  default     = true
}

variable "required_status_checks" {
  description = "A list of status checks (contexts) that must pass before a branch can be merged into the protected branch."
  type        = set(string)
  default     = []
}

variable "dismiss_stale_reviews" {
  description = "Dismiss approved reviews automatically when a new commit is pushed."
  type        = bool
  default     = true
}

variable "require_code_owner_reviews" {
  description = "Whether or not an approval is required from code owners to merge a pull request."
  type        = bool
  default     = true
}

variable "review_dismissal_restrictions" {
  description = "The list of actor IDs with dismissal access."
  type        = set(string)
  default     = []
}

variable "required_approving_review_count" {
  description = "The number of approvals required to satisfy branch protection requirements. This must be a number between 1 and 6."
  type        = number
  default     = 1
}

variable "pull_request_bypassers" {
  description = "A list of actor names or IDs that are allowed to bypass pull request requirements. Actor names must either begin with a `/` for users or the organization name followed by a `/` for teams."
  type        = set(string)
  default     = []
}

variable "require_last_push_approval" {
  description = "Require that the most recent push must be approved by someone other than the last pusher. Defaults to `false`."
  type        = bool
  default     = false
}
