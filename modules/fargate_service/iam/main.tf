locals {
  ecs_task_execution_role_name = "${var.name}-ecs-task-execution-role"
  ecs_task_role_name           = "${var.name}-ecs-task-role"
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS_TASK_EXECUTION_ROLE
# This is the role that the Amazon ECS container agent and the Docker daemon can assume
# **This will be the same for all services
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name = local.ecs_task_execution_role_name
  path = "/service-role/"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json
  inline_policy {
    name   = "${var.name}-ecs-task-execution-policy"
    policy = data.aws_iam_policy.ecs_task_execution_role_policy.policy
  }

  tags = merge({ Name = local.ecs_task_execution_role_name }, var.tags)
}

data "aws_iam_policy_document" "ecs_tasks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS_TASK_ROLE
# This is the role that the allows the Amazon ECS container task to make calls to other AWS services
# **This will be unique per service. IAM_Policies will need to be passed in
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  name = local.ecs_task_role_name
  path = "/service-role/"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json
  inline_policy {
    name   = "${var.name}-ecs-task-policy"
    policy = data.aws_iam_policy_document.ecs_task_policy.json
  }

  tags = merge({ Name = local.ecs_task_role_name }, var.tags)
}

data "aws_iam_policy_document" "ecs_task_policy" {
  # by default add log creation
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:AssociateKmsKey"
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.iam_policies
    content {
      actions   = statement.value.Actions
      resources = statement.value.Resources
      effect    = statement.value.Effect
      sid       = statement.key
    }
  }
}
