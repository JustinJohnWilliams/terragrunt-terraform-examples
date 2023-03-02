# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.

locals {
  account_name   = "<MY PROD AWS ACCOUNT NAME>"
  aws_account_id = "<MY PROD AWS ACCOUNT ID>"
  env            = "prod"
}
