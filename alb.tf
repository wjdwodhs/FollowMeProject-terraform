resource "aws_lb" "followme_alb" {
  name               = "followme-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "followme-alb"
  }
}

resource "aws_lb_listener" "https_listener_443" {
  load_balancer_arn = aws_lb.followme_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn  # ACM 인증서 ARN 변수로 관리

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.followme_tg_blue.arn
  }
}


resource "aws_lb_listener" "http_listener_8081" {
  load_balancer_arn = aws_lb.followme_alb.arn
  port              = 8081
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.followme_tg_green.arn
  }
}

resource "aws_lb_target_group" "followme_tg_blue" {
  name     = "tg-blue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/healthcheck.jsp"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  target_type = "instance"
}

resource "aws_lb_target_group" "followme_tg_green" {
  name     = "tg-green"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/healthcheck.jsp"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  target_type = "instance"
}

