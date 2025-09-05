# Application Load Balancer (internet-facing)
resource "aws_lb" "alb" {
  name               = "ecoshop-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.sg_web.id]
  subnets            = [for s in aws_subnet.public : s.id]
  tags = { Name = "ecoshop-alb" }
}

# Target Group sur port 80 avec health check /index.php
resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/index.php"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Enregistrement des cibles (instances app)
resource "aws_lb_target_group_attachment" "app_attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}

# Listener HTTP 80 -> Target Group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}