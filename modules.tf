module "my-vpc" {
    source = "./main"
    vpc_cidr = "10.0.0.0/16"
    v_vpc_id = module.my-vpc.v_vpc_id
    v_sn1 = module.my-vpc.v_sn1
    v_sn2 = module.my-vpc.v_sn2
    az = module.my-vpc.az
    bastion-ingressports = [22,80]
    bastion-egressports = [80]
    sg_bastion_cidr_blocks = ["0.0.0.0/0"]
    sg_id_bastion = module.my-vpc.sg_id_bastion
    interval = "10"
    port = 80
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    desired = 2
    min = 1
    max = 5
}

