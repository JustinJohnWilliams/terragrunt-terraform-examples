locals {
  alb_name    = "${var.name}-alb-${var.env}"
  alb_tg_name = "${var.name}-tg-${var.env}"
}

resource "aws_lb" "main" {
  name               = local.alb_name
  subnets            = var.subnets
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups

  enable_deletion_protection = false

  tags = merge({ Name = local.alb_name }, var.tags)
}

resource "aws_alb_target_group" "main" {
  name        = local.alb_tg_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = merge({ Name = local.alb_tg_name }, var.tags)
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

# Redirect traffic to target group
#resource "aws_alb_listener" "https" {
#  load_balancer_arn = aws_lb.main.id
#  port              = 443
#  protocol          = "HTTPS"

#  ssl_policy      = "ELBSecurityPolicy-2016-08"
#  certificate_arn = var.alb_tls_cert_arn

#  default_action {
#    target_group_arn = aws_alb_target_group.main.id
#    type             = "forward"
#  }
#}
