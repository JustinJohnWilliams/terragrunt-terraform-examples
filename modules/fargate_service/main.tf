terraform {
  required_version = ">= 1.2.9"
  backend "s3" {}
}

provider "aws" {
  region              = var.region
  allowed_account_ids = ["${var.aws_account_id}"]
}

locals {
  tags = merge(var.tags, var.default_tags)
}

module "security_groups" {
  source = "./security_groups"

  name           = var.name
  vpc_id         = var.vpc_id
  env            = var.env
  container_port = var.container_port

  tags = local.tags
}

module "alb" {
  source = "./alb"

  name                = var.name
  vpc_id              = var.vpc_id
  env                 = var.env
  subnets             = var.public_subnets
  alb_security_groups = [module.security_groups.alb]
  health_check_path   = var.health_check_path

  tags = local.tags
}

module "ecr" {
  source = "./ecr"

  name       = var.name
  env        = var.env
  max_images = var.ecr_max_images

  tags = local.tags
}

module "ecs" {
  source = "./ecs"

  name                        = var.name
  env                         = var.env
  region                      = var.region
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  container_image             = module.ecr.aws_ecr_repository_url
  container_port              = var.container_port
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  subnets                     = var.private_subnets
  alb_target_group_arn        = module.alb.aws_alb_target_group_arn

  tags = local.tags
}
