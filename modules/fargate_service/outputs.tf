output "alb_dns" {
  value = module.alb.dns_name
}

output "ecr_url" {
  value = module.ecr.aws_ecr_repository_url
}
