resource "aws_lb" "wordpress_lb" {
  name                       = "wordpress-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.wp.id]
  subnets                    = aws_subnet.public_subnets.*.id
  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_target_group" "wordpress_tg" {
  name                          = "wordpress-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.main.id
  load_balancing_algorithm_type = "round_robin"
  protocol_version              = "HTTP1"
  slow_start                    = "600"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 3
    matcher             = "200"
  }

  stickiness {
    cookie_duration = "86400"
    cookie_name     = "cookie"
    enabled         = "true"
    type            = "app_cookie"
  }
}

resource "aws_lb_listener" "http_listner" {
  load_balancer_arn = aws_lb.wordpress_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}
