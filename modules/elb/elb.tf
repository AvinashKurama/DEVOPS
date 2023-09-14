
/*-------------Target-Group-1------------*/

resource "aws_lb_target_group" "tg1" {
  name     = "lb-tg"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.v_vpc1
  health_check {
    interval            = var.interval
    port                = var.port
    protocol            = var.protocol
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

/*-------------ALB------------*/

resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb-1]
  subnets            = var.v_sn1

  tags = {
    Environment = "production-alb"
  }
}

/*-------------ALB-lis-----------*/

resource "aws_lb_listener" "alb_li" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
     type = "forward"
     target_group_arn =  var.v_targetgroup1
  }
}
