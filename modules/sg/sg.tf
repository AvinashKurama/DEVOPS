
resource "aws_security_group" "sg-webserver" {
 vpc_id = var.v_vpc
 name = "webserver"
 description = "Security Group for Web Servers"

 dynamic "ingress" {
  for_each = var.inbound_ports
 content {
   from_port = ingress.value
   to_port = ingress.value
   protocol = "tcp"
   cidr_blocks = var.ingress.cidr_block
  }
 }

 dynamic "egress" {
  for_each = var.outbound_ports
  content {
   from_port = egress.value
   to_port = egress.value
   protocol = "tcp"
   cidr_blocks = var.egress.cidr_block
  }
 }

 tags = {
    Name = "sg-webserver-${terraform.workspace}"
  }
}
