output "name" {
  value = github_repository.repository.name
}

output "clone" {
  value = {
    ssh   = github_repository.repository.ssh_clone_url
    https = github_repository.repository.http_clone_url
  }
}

output "id" {
  value = github_repository.repository.id
}

output "default_branch" {
  value = github_branch_default.default_branch[0].branch

}
