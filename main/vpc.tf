module "my-vpc1"{

 source = "../modules/vpc"
 vpc1_cidr = "10.0.0.0/16"
 az = module.my-vpc1.az
 vpc1-sn1 = module.my-vpc1.sn1
 vpc1-sn2 = module.my-vpc1.sn2
 
 }
 
 