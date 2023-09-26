module "my_network" {
source = "../modules/network"

v_az = module.my_network.v_az
v_cidr_block = "10.0.0.0/16"
v_vpc = module.my_network.v_vpc
v_sn1 = module.my_network.v_sn1
v_sn2 = module.my_network.v_sn2
  
}