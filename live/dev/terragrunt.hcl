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

remote_state {
  backend = "s3"
  config = {
    bucket = "<MY STATE BUCKET>"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "<MY STATE DYNAMO DB TABLE>"
  }
}


inputs = {
  account_name   = local.account_name
  aws_account_id = local.aws_account_id
  env            = local.env
  region         = local.region
  default_tags   = local.default_tags
}