resource "aws_lb" "hayley-alb" {
  name               = "t101-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.hayley-subnet1.id, aws_subnet.hayley-subnet2.id]
  security_groups = [aws_security_group.hayley-sg.id]

  tags = {
    Name = "t101-alb"
  }
}

resource "aws_lb_listener" "hayley-http" {
  load_balancer_arn = aws_lb.hayley-alb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "hayley-albtg" {
  name = "t101-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.hayley-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "hayley-albrule" {
  listener_arn = aws_lb_listener.hayley-http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hayley-albtg.arn
  }
}

output "hayley-alb_dns" {
  value       = aws_lb.hayley-alb.dns_name
  description = "The DNS Address of the ALB"
}