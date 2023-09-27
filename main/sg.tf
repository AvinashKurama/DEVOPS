module "my_sg_webserver" {
    source = "../modules/sg"

    v_vpc = module.my_network.v_vpc
    inbound_ports = [22,80,8080]
    outbound_ports = [0]
    ingress_cidr_block = ["0.0.0.0/0"]
    egress_cidr_block = ["0.0.0.0/0"]
    v_sg_web = module.my_sg_webserver.v_sg_web

}