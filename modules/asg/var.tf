/*-------------lunch-template-----------*/
variable "image_id" {
  type = string
}

variable "instance_type" {
}

/*-------------auto-scalling-------------*/

variable "desired" {
  default = []

}

variable "min" {
  default = []
}
variable "max" {
  default = []
}

variable "v_sn1" {
}

variable "sg_webser-1"{

}

variable "v_targetgroup1"{  
}