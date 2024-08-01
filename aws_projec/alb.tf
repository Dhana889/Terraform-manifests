resource "aws_lb" "webfacing" {
  name               = "application-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.public1a.id, aws_subnet.public1b.id]

  tags = {
    Name = "Application LoadBalancer"
  }
}

resource "aws_lb_target_group" "alb_target" {
  name     = "tf-application-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "link1" {
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.webserver01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "link2" {
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.webserver02.id
  port             = 80
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.webfacing.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}