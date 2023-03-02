terraform {
  source = "../../../modules/state_config"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_name   = local.account_vars.locals.account_name
  aws_account_id = local.account_vars.locals.aws_account_id
  env            = local.account_vars.locals.env
  region         = local.region_vars.locals.region

  default_tags = {
    env               = local.env
    account_name      = local.account_name
    region            = local.region
    terraform_managed = true
  }
}

inputs = {
  region         = local.region
  aws_account_id = local.aws_account_id
  env            = local.env

  bucket_name   = "<MY PROD STATE BUCKET NAME>"
  table_name    = "<MY PROD STATE DYNAMO DB TABLE>"
  hash_key      = "LockID"
  hash_key_type = "S"
  billing_mode  = "PAY_PER_REQUEST"
}