variable "inbound_ports" {
  type = list(number)
}


variable "ingress_cidr" {
  default = []
}


variable "outbound_ports" {
  type = list(number)
}


variable "egress_cidr" {
  default = []
}


variable "sg_webser-1" {
  type = string
}

/*-------------var-2------------*/

variable "inbound_ports1" {
  type = list(number)
}


variable "ingress_cidr1" {
  default = []
}


variable "outbound_ports1" {
  type = list(number)
}


variable "egress_cidr1" {
  default = []
}


variable "sg_alb-1" {
  type = string
}

variable "v_vpc1" {
}

