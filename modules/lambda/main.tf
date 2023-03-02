terraform {
  required_version = ">= 1.2.9"
  backend "s3" {}
}

provider "aws" {
  region              = var.region
  allowed_account_ids = ["${var.aws_account_id}"]
}

locals {
  lambda_role_name           = "${var.function_name}-lambda-role"
  cloudwatch_event_rule_name = "${var.function_name}-schedule"
  lambda_zip_file            = var.zip_dir == null ? "${path.module}/default_lambda.zip" : var.zip_dir
  tags                       = merge(var.default_tags, var.tags)
}

module "iam_role" {
  source = "./iam_role"

  name           = local.lambda_role_name
  custom_actions = var.custom_actions
  tags           = local.tags
}

module "event_bridge" {
  source = "./event_bridge"

  enabled     = var.enable_event_bridge
  name        = local.cloudwatch_event_rule_name
  description = "Schedule for ${var.function_name}"
  schedule    = "cron(${var.cron_expression})"
  event_input = var.event_input

  lambda_arn  = aws_lambda_function.lambda.arn
  lambda_name = var.function_name

  tags = local.tags
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = local.lambda_zip_file
  role             = module.iam_role.role_arn
  handler          = var.handler
  source_code_hash = filebase64sha256(local.lambda_zip_file)

  runtime     = var.runtime
  timeout     = var.timeout
  memory_size = var.memory_size
  tags        = local.tags
}
