locals {
  cluster_name                 = "${var.name}-cluster-${var.env}"
  task_definition_name         = "${var.name}-task-${var.env}"
  container_name               = "${var.name}-container-${var.env}"
  ecs_task_role_name           = "${var.name}-ecs-task-role"
  iam_policy_s3_name           = "${var.name}-task-policy-s3"
  ecs_task_execution_role_name = "${var.name}-ecs-task-execution-role"
  ecs_service_name             = "${var.name}-service-${var.env}"
  log_group_name               = "/ecs/${var.name}-task-${var.env}"
}

resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  tags = merge({ Name = local.cluster_name }, var.tags)
}

resource "aws_ecs_task_definition" "main" {
  family                   = local.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn #TODO: move this out
  container_definitions = jsonencode([{
    name  = local.container_name
    image = "${var.container_image}:latest"
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = merge({ Name = local.task_definition_name }, var.tags)
}

resource "aws_iam_role" "ecs_task_role" {
  #NOTE: this should probably be passed in with application specific services
  name               = local.ecs_task_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge({ Name = local.ecs_task_role_name }, var.tags)
}

# TODO: pass this role in
resource "aws_iam_policy" "s3" {
  name        = local.iam_policy_s3_name
  description = "Policy that allows access to S3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  tags = merge({ Name = local.iam_policy_s3_name }, var.tags)
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment_s3" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = local.ecs_task_execution_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge({ Name = local.ecs_task_execution_role_name }, var.tags)
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "main" {
  name = local.log_group_name

  tags = merge({ Name = local.log_group_name }, var.tags)
}

resource "aws_ecs_service" "main" {
  name                 = local.ecs_service_name
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.main.arn
  desired_count        = var.ecs_service_desired_count
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  tags = merge({ Name = local.ecs_service_name }, var.tags)
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
