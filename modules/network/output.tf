output "az" {
  value = data.aws_availability_zones.az1.names
}

output "v_sn1" {
  value = aws_subnet.pub-sn.*.id
}

output "v_sn2" {
  value = aws_subnet.prv-sn.*.id
}

output "v_vpc1" {
  value = aws_vpc.vpc1.id
}

