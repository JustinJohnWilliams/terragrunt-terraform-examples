terraform {
  required_version = ">= 1.2.9"
  backend "s3" {}
}

locals {
  topics = concat(var.topics, ["terraform-managed"])
}

resource "github_repository" "repository" {
  name               = var.name
  description        = var.description
  visibility         = var.private ? "private" : "public"
  homepage_url       = var.homepage_url
  topics             = local.topics
  is_template        = var.is_template
  auto_init          = var.auto_init
  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  has_issues    = var.has_issues
  has_wiki      = var.has_wiki
  has_downloads = var.has_downloads
  has_projects  = var.has_projects

  allow_merge_commit  = var.allow_merge_commit
  allow_squash_merge  = var.allow_squash_merge
  allow_rebase_merge  = var.allow_rebase_merge
  allow_auto_merge    = var.allow_auto_merge
  allow_update_branch = var.allow_update_branch

  delete_branch_on_merge = var.delete_branch_on_merge

  dynamic "template" {
    for_each = var.template_owner != null && var.template_repository != null ? [1] : []
    content {
      owner      = var.template_owner
      repository = var.template_repository
    }
  }
}

resource "github_branch_default" "default_branch" {
  count      = signum(length(var.default_branch))
  repository = github_repository.repository.name
  branch     = var.default_branch
}

module "default_branch_protection" {
  source = "./branch_protection"

  repository_id = github_repository.repository.id
  pattern       = github_branch_default.default_branch[0].branch

  enforce_admins                  = var.default_branch_protection_enforce_admins
  required_status_checks          = var.default_branch_protection_required_status_checks
  strict                          = var.default_branch_protection_strict
  allows_force_pushes             = var.default_branch_allow_force_pushes
  require_linear_history          = var.default_branch_require_linear_history
  dismiss_stale_reviews           = var.dismiss_stale_reviews
  require_code_owner_reviews      = var.require_code_owner_reviews
  require_signed_commits          = var.require_signed_commits
  push_restrictions               = var.push_restrictions
  review_dismissal_restrictions   = var.review_dismissal_restrictions
  required_approving_review_count = var.required_approving_review_count
}

resource "github_team_repository" "pull_teams" {
  for_each = var.pull_teams

  team_id = each.value
  repository = github_repository.repository.name
  permission = "pull"
}

resource "github_team_repository" "push_teams" {
  for_each = var.push_teams

  team_id = each.value
  repository = github_repository.repository.name
  permission = "push"
}

resource "github_team_repository" "admin_teams" {
  for_each = var.admin_teams

  team_id = each.value
  repository = github_repository.repository.name
  permission = "admin"
}

resource "github_repository_collaborator" "pull_users" {
  for_each = var.pull_users

  username = each.value
  repository = github_repository.repository.name
  permission = "pull"
}

resource "github_repository_collaborator" "push_users" {
  for_each = var.push_users

  username = each.value
  repository = github_repository.repository.name
  permission = "push"
}

resource "github_repository_collaborator" "admin_users" {
  for_each = var.admin_users

  username = each.value
  repository = github_repository.repository.name
  permission = "admin"
}
