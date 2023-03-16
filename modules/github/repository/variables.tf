# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "The name of the repository"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "description" {
  type        = string
  description = "A description of the repository"
  default     = ""
}

variable "private" {
  type        = bool
  description = "Set to `true` to create a private repository"
  default     = true
}

variable "homepage_url" {
  type        = string
  description = "URL of a page describing the project"
  default     = ""
}

variable "topics" {
  type        = list(string)
  description = "The list of topics for the repository"
  default     = []
}

variable "is_template" {
  type        = bool
  description = "Set to `true` to tell GitHub that this is a template repository"
  default     = false
}

variable "auto_init" {
  type        = bool
  description = "Set to `true` to produce an initial commit in the repository"
  default     = true
}

variable "gitignore_template" {
  type        = string
  description = "Use the name of the template without the extension. https://github.com/github/gitignore. e.g. 'Terraform'"
  default     = ""
}

variable "license_template" {
  type        = string
  description = "Use the name of the template without the extension. https://github.com/github/choosealicense.com/tree/gh-pages/_licenses. e.g. 'mit'"
  default     = ""
}

variable "has_issues" {
  type        = bool
  description = "Set to `true` to enable GitHub issues"
  default     = false
}

variable "has_wiki" {
  type        = bool
  description = "Set to `true` to enable GitHub Wiki features"
  default     = false
}

variable "has_downloads" {
  type        = bool
  description = "Set to `true` to enable the (deprecated) downloads features"
  default     = false
}

variable "has_projects" {
  type        = bool
  description = "Set to `true` to enable the the GitHub Projects features"
  default     = false
}

variable "allow_merge_commit" {
  type        = bool
  description = "Set to `false` to disable merge commits on the repository"
  default     = true
}

variable "allow_squash_merge" {
  type        = bool
  description = "Set to `false` to disable squash merges on the repository"
  default     = true
}

variable "allow_rebase_merge" {
  type        = bool
  description = "Set to `false` to disable rebase merges on the repository"
  default     = true
}

variable "allow_auto_merge" {
  type        = bool
  description = "Set to `true` to allow auto-merging pull requests on the repository"
  default     = false
}

variable "allow_update_branch" {
  type        = bool
  description = "Set to `true' to always suggest updating pull requests"
  default     = false
}

variable "delete_branch_on_merge" {
  type        = bool
  description = "Automatically delete head branch after a pull request is merged."
  default     = false
}

variable "template_owner" {
  type        = string
  description = "The owner of the template repository"
  default     = null
}

variable "template_repository" {
  type        = string
  description = "The name of the template repository"
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE PROTECTION FOR THE DEFAULT BRANCH
# ---------------------------------------------------------------------------------------------------------------------
variable "default_branch" {
  type        = string
  description = "The name of the default branch for the repository"
  default     = "main"
}

variable "default_branch_protection_enforce_admins" {
  description = "Setting this to true enforces status checks for repository administrators. In general this should be false to allow admins and service accounts to reconcile branches after a release without creating trailing merge commits -- branches would never be current with one another."
  type        = bool
  default     = false
}

variable "default_branch_protection_required_status_checks" {
  description = "A set of status checks (contexts) that must pass before a branch can be merged into the protected branch."
  type        = list(string)
  default     = []
}

variable "default_branch_protection_strict" {
  description = "Setting this to true enforces that a branch be current with the base branch before merging."
  type        = bool
  default     = false
}

variable "default_branch_allow_force_pushes" {
  description = "Setting this to true allows force pushes to default branch"
  type        = bool
  default     = false
}

variable "default_branch_require_linear_history" {
  description = "Setting this to `true` enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch."
  type        = bool
  default     = false
}

variable "dismiss_stale_reviews" {
  description = "Dismiss approved reviews automatically when a new commit is pushed."
  type        = bool
  default     = true
}

variable "require_code_owner_reviews" {
  description = "Whether or not an approval is required from code owners to merge a pull request."
  type        = bool
  default     = false
}

variable "require_signed_commits" {
  description = "Requires all commits in the branch to be signed with GPG."
  type        = bool
  default     = false
}

variable "push_restrictions" {
  description = "A list of actor IDs that are explicitly permitted to push to the branch. Admins have this capability if `enforce_admins` is false."
  type        = list(string)
  default     = []
}

variable "review_dismissal_restrictions" {
  description = "The list of actor IDs with permission to dismiss reviews."
  type        = list(string)
  default     = []
}

variable "required_approving_review_count" {
  description = "The number of approvals required to satisfy branch protection requirements. This must be a number between 1 and 6."
  type        = number
  default     = 1
}

variable "pull_teams" {
  description = "A set of teams allowed to pull this repository"
  type        = set(string)
  default     = []
}

variable "push_teams" {
  description = "A set of team IDs allowed to push to this repository"
  type        = set(string)
  default     = []
}

variable "admin_teams" {
  description = "A set of team IDs allowed to administer this repository"
  type        = set(string)
  default     = []
}

variable "pull_users" {
  description = "A set of GitHub users' IDs allowed to read this repository"
  type        = set(string)
  default     = []
}

variable "push_users" {
  description = "A set of GitHub users' IDs allowed to write to this repository"
  type        = set(string)
  default     = []
}

variable "admin_users" {
  description = "A set of GitHub users' IDs allowed to admin this repository"
  type        = set(string)
  default     = []
}
