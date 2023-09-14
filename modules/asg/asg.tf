resource "aws_launch_template" "my_lt" {
  name = "my_launch_template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  image_id = var.image_id

  instance_type = var.instance_type

  key_name = "tfkey"

  vpc_security_group_ids = [var.sg_webser-1]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "MyNewLT"
    }
  }

  user_data = filebase64("./userdata.sh")
}


/*-------------auto-scalling-group------------*/


resource "aws_autoscaling_group" "asg-1" {
  name                      = "ags-terraform"
  max_size                  = var.max
  min_size                  = var.min
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired
  vpc_zone_identifier       = (slice(var.v_sn1, 0, length(var.v_sn1)))
  target_group_arns         = [var.v_targetgroup1]

  launch_template {
    id      = aws_launch_template.my_lt.id
    version = "$Latest"
  }
}