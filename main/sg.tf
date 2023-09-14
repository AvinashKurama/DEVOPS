module "my-sg" {

  source          = "../modules/Securitygroup"
  inbound_ports   = [22,80]
  outbound_ports  = [22,80]
  ingress_cidr    = ["0.0.0.0/0"]
  egress_cidr     = ["0.0.0.0/0"]
  sg_webser-1     = module.my-sg.sg_webser-1
  inbound_ports1  = [80]
  outbound_ports1 = [0]
  ingress_cidr1   = ["0.0.0.0/0"]
  egress_cidr1    = ["0.0.0.0/0"]
  sg_alb-1        = module.my-sg.sg_alb-1
  v_vpc1          = module.my-network.v_vpc1
}
 