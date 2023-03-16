terraform {
  required_version = ">= 1.2.9"
  backend "s3" {}
}

resource "github_team" "team" {
  name           = var.name
  description    = var.description
  privacy        = var.privacy
  parent_team_id = var.parent_team_id
}

resource "github_team_membership" "maintainers" {
  for_each = toset(var.maintainers)

  team_id  = github_team.team.id
  username = each.key
  role     = "maintainer"

  lifecycle {
    ignore_changes = [role] // Org owners may not be set as "member" of a team. They can only be "maintainers". Attempting to set organization owner to "member" may result in terraform plan diff
  }
}

