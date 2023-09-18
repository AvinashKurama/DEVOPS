module "my-vpc1"{

 source = "../modules/vpc"
 vpc1_cidr = "10.0.0.0/16"
 az = module.my-vpc1.az
 vpc1_sn1 = module.my-vpc1.vpc1_sn1
 vpc1_sn2 = module.my-vpc1.vpc1_sn2
 vpc1 = module.my-vpc1.vpc1
 
 }
 
 