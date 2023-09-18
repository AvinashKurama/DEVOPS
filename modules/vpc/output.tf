output "az"{
  value = data.aws_availability_zones.az1.names
  }

output "vpc1"{
  value = aws_vpc.vpc1.id
  }
  
output "vpc1_sn1"{
  value = aws_subnet.pub-sn1.*.id
  }
  
output "vpc1_sn2"{
  value = aws_subnet.prv-sn2.*.id
  }




