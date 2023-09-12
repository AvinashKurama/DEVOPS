
data "aws_availability_zones" "az1" {
  state = "available"
}



resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
}



resource "aws_subnet" "pub-sub" {
  count = length(var.az)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "sub-${count.index}"
  }
}



resource "aws_subnet" "priv-sub" {
  count = length(var.az)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = cidrsubnet(var.vpc_cidr,8,(count.index+length(var.az)))
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = false
  
  tags = {
    Name = "Priv-sub-${count.index}"
  }
}

/*-----------IGW-EIP-NAT-RT-------------------*/


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
}


resource "aws_eip" "eip" {
  
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub-sub.*.id[0]

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"	
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt-pub"
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"	
    gateway_id = aws_nat_gateway.nat1.id
  }
  tags = {
    Name = "rt-priv"
  }
}

resource "aws_route_table_association" "a" {
  count = length(var.az)
  subnet_id = aws_subnet.pub-sub.*.id[count.index]
  route_table_id = aws_route_table.rt1.id
}


resource "aws_route_table_association" "b" {
  count = length(var.az)
  subnet_id      = aws_subnet.priv-sub.*.id[count.index]
  route_table_id = aws_route_table.rt2.id
}

/*-----------Bastion-Security-group-------------------*/

resource "aws_security_group" "bastion-sg"{
    vpc_id = var.v_vpc_id
    name = "bastion-sg"

    dynamic "ingress"{
        iterator = port
        for_each = var.bastion-ingressports
        content{
            from_port = port.value
            to_port = port.value
            protocol = "TCP" 
            cidr_blocks = var.sg_bastion_cidr_blocks
        }
    }
    dynamic "egress"{
        iterator = port
        for_each = var.bastion-egressports
        content{
            from_port = port.value
            to_port = port.value
            protocol = "TCP" 
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    tags = {
        Name = "bastion-sg"
    }
}


resource "aws_security_group" "alb-sg" {
  vpc_id = var.v_vpc_id
  name =  "alb-sg"
  ingress  {
      from_port = "80"
      to_port = "80"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress  {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
}

/*-----------Application-ELB-------------------*/


resource "aws_lb_target_group" "tg1" {
  name = "target-1"
  port = var.port
  protocol = var.protocol
  vpc_id = var.v_vpc_id

  health_check {
      interval = var.interval
      port = var.port
      protocol = var.protocol
      healthy_threshold = var.healthy_threshold
      unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb" "ALB1" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = aws_subnet.pub-sub[*].id


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "my-alb-listener" {
  port = var.port
  protocol = var.protocol
  load_balancer_arn = aws_lb.ALB1.arn
  default_action {
    type = "forward"
    target_group_arn =  aws_lb_target_group.tg1.arn
  }
}

/*-----------Auto-scaling-group------------------*/



resource "aws_autoscaling_group" "my-asg1" {
  name = "my-asg"
  vpc_zone_identifier = slice(var.v_sn1,0,length(var.v_sn1))
  target_group_arns = [aws_lb_target_group.tg1.arn]
  desired_capacity = var.desired
  max_size = var.max
  min_size = var.min

  launch_template { 
    id = aws_launch_template.mylt.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "mylt" {
  # Name of the launch template
  name          = "first-template"

  # ID of the Amazon Machine Image (AMI) to use for the instance
  image_id      = "ami-053b0d53c279acc90"

  # Instance type for the EC2 instance
  instance_type = "t2.micro"

  # SSH key pair name for connecting to the instance
  key_name = "tfkey"

  # Block device mappings for the instance
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      # Size of the EBS volume in GB
      volume_size = 20

      # Type of EBS volume (General Purpose SSD in this case)
      volume_type = "gp2"
    }
  }

  # Network interface configuration
  network_interfaces {
    # Associates a public IP address with the instance
    associate_public_ip_address = true

    # Security groups to associate with the instance
    security_groups = [var.sg_id_bastion]
  }

  # Tag specifications for the instance
  tag_specifications {
    # Specifies the resource type as "instance"
    resource_type = "instance"

    # Tags to apply to the instance
    tags = {
      Name = "first template"
    }
  }
  user_data = filebase64("./main/userdata.sh")
}

