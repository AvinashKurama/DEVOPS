output "az"{
  value = data.aws_availability_zones.az1.names
  }

output "v_vpc_id"{
  value = aws_vpc.vpc1.id
  }
  
output "v_sn1"{
  value = aws_subnet.pub-sub.*.id
  }
  
output "v_sn2"{
  value = aws_subnet.priv-sub.*.id
  }
  
output "sg_id_bastion" {
    value = aws_security_group.bastion-sg.id
}


