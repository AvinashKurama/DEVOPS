output "v_az"{
    value = data.aws_availability_zones.available.names
}

output "v_vpc" {
  value = aws_vpc.v_vpc_1.id
}

output "v_sn1" {
    value = aws_subnet.sn1.*.id
}

output "v_sn2" {
    value = aws_subnet.sn2.*.id
}

