terraform {
  required_version = ">= 1.2.9"
  backend "s3" {}
}

resource "github_membership" "membership" {
  username = var.username
  role     = var.organization_role
}

resource "github_team_membership" "members" {
  for_each = toset(var.teams)

  team_id  = each.key
  username = github_membership.membership.username
  role     = "member"

  lifecycle {
    ignore_changes = [role] // Org owners may not be set as "member" of a team. They can only be "maintainers". Attempting to set organization owner to "member" may result in terraform plan diff
  }
}
