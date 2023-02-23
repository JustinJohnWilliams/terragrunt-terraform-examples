# Even for global resources, you still need an AWS region for Terraform to talk to
locals {
  region = "us-east-2"
  azs = ["us-east-2a","us-east-2b","us-east-2c"]
}