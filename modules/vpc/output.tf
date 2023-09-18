output "az"{
  value = aws_availability_zones.az1.name
  }

output "v_vpc_id"{
  value = aws_vpc.vpc1.id
  }
  
output "v_sn1"{
  value = aws_subnet.pub-sub.*.id
  }
  
output "v_sn1"{
  value = aws_subnet.priv-sub.*.id
  }
  
output "sg_id_bastion" {
    value = aws_security_group.bastion-sg.id
}



