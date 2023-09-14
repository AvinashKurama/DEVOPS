
output "sg_webser-1" {
  value = aws_security_group.sg-webserver.id
}


output "sg_alb-1" {
  value = aws_security_group.sg-alb.id
}

