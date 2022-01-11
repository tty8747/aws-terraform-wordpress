resource "aws_lb" "this" {
  name               = var.lbname
  internal           = false
  load_balancer_type = "application"
  subnets            = [for i in aws_subnet.this : i.id]
  security_groups    = [aws_security_group.this.id]

  enable_cross_zone_load_balancing = true

  tags = {
    Name = var.lbname
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "aws_security_group" "this" {
  name   = "wp-lb-sgroup"
  vpc_id = var.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    host_header {
      values = ["*.amazonaws.com", var.fqdn]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = "lb${var.internal_port}"
  port        = var.internal_port
  protocol    = "HTTP"
  vpc_id      = var.vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299,301,302"
    interval            = 100
    timeout             = 30
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }

  stickiness {
    cookie_name = "myapp"
    type        = "app_cookie"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count            = length(var.target_ids)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_ids[count.index]
}


resource "aws_autoscaling_group" "ubuntu20" {
  launch_configuration = aws_launch_configuration.ubuntu20.name
  vpc_zone_identifier  = var.usefullsubnets

  target_group_arns = [aws_lb_target_group.this.arn]
  health_check_type = "ELB"

  min_size = 1
  max_size = 2

  tag {
    key                 = "Name"
    value               = "autoscaling group"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}

resource "aws_launch_configuration" "ubuntu20" {
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_id

  security_groups = var.private_sgroups_ids
  user_data       = var.init-script

  lifecycle {
    create_before_destroy = true
  }
}
