variable "port" {
  type = number
}

variable "protocol" {
  default = ""
}

variable "interval" {
}

variable "healthy_threshold" {
}

variable "unhealthy_threshold" {
}

variable "v_vpc1" {
}

variable "sg_alb-1" {
}

variable "v_sn1" {
}

output "v_targetgroup1"{
  value = aws_lb_target_group.tg1.arn
}

variable "v_targetgroup1"{  
}