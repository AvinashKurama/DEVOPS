module "my-network" {
  source   = "../modules/network"
  vpc_cidr = "10.0.0.0/16"
  az       = module.my-network.az
  v_vpc1   = module.my-network.v_vpc1
  v_sn1    = module.my-network.v_sn1
  v_sn2    = module.my-network.v_sn2
}