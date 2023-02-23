locals {
  sg_alb_name  = "${var.name}-sg-alb-${var.env}"
  sg_task_name = "${var.name}-sg-task-${var.env}"
}

resource "aws_security_group" "alb" {
  name   = local.sg_alb_name
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.sg_alb_name }, var.tags)
}

resource "aws_security_group" "ecs_tasks" {
  name   = local.sg_task_name
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.container_port
    to_port     = var.container_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.sg_task_name }, var.tags)
}
