variable "v_vpc" {
}

variable "inbound_ports" {
 type = list(number) 
}

variable "outbound_ports" {
 type = list(number) 
}

variable "ingress_cidr_block" {
    default = []
}

variable "egress_cidr_block" {
    default = []
}

variable "v_sg_web" {
    default = []  
}