# Even for global resources, you still need an AWS region for Terraform to talk to
locals {
  region             = "us-east-2"
  availability_zones = [""]
}