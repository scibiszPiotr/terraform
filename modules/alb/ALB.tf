resource "aws_alb" "pscibisz-alb" {
  name            = "pscibisz-alb"
  security_groups = [var.sg_http_id]
  subnets         = [for s in var.public_subnets : s.id]
  tags = {
    Name = "pscibisz-alb"
  }
}

resource "aws_alb_target_group" "pscibisz-tg" {
  count = length(var.listeners)

  name     = "pscibisz-${lookup(var.listeners[count.index], "name")}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/${lookup(var.listeners[count.index], "name")}/"
    port = 80
  }

  tags = {
    app = lookup(var.listeners[count.index], "name")
  }
}

resource "aws_lb_listener" "pscibisz-listener" {
  load_balancer_arn = aws_alb.pscibisz-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "redirect" {
  count = length(var.listeners)

  listener_arn = aws_lb_listener.pscibisz-listener.arn
  priority     = lookup(var.listeners[count.index], "id")

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.pscibisz-tg[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/${lookup(var.listeners[count.index], "name")}/*"]
    }
  }
}
