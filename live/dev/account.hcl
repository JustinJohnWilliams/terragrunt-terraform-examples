# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.

locals {
  account_name   = "<MY DEV AWS ACCOUNT NAME>"
  aws_account_id = "<MY DEV AWS ACCOUNT ID>"
  env            = "dev"
}
