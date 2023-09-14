
/*-------------security-group-1------------*/

resource "aws_security_group" "sg-webserver" {
  name        = "webserver"
  description = "Security Group for Web Servers"
  vpc_id      = var.v_vpc1

  dynamic "ingress" {
    iterator = port
    for_each = var.inbound_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.outbound_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.egress_cidr
    }
  }
}


/*-------------security-group-2------------*/

resource "aws_security_group" "sg-alb" {
  name        = "alb"
  description = "Security Group for Web Servers"
  vpc_id      = var.v_vpc1

  dynamic "ingress" {
    iterator = port
    for_each = var.inbound_ports1
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr1
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.outbound_ports1
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = var.egress_cidr1
    }
  }
}


