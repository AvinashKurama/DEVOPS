variable "az"{
  default = []
}

variable "vpc_cidr" {
}

variable "v_vpc_id" {
}

variable "v_sn1" {
  default = []
}

variable "v_sn2" {
  default = []
}

variable "tags_common" {
   default = {
   Owner = "avinash"
   env = "dev"
   }
}

variable "bastion-ingressports"{
    type = list(number)
}

variable "bastion-egressports"{
    type = list(number)
}

variable "sg_bastion_cidr_blocks"{
    default = []
}

variable "sg_id_bastion"{
    type = string
}


/*-----------target-group-------------------*/


variable "interval" {
  default = 10
}

variable "port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "healthy_threshold" {
  default = 3
}

variable "unhealthy_threshold" {
  default = 3
}

variable "desired" {
    default = [] 
}

variable "min" {
  default = []
}
variable "max" {
  default = []
}
