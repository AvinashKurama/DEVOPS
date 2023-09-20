module "my_eks"{
   source = "../modules/eks_node"
   vpc1_sn1 = module.my-vpc1.vpc1_sn1
   
}

