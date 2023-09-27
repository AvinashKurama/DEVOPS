module "my_instance" {
    source = "../modules/instance"

    v_ami = "ami-053b0d53c279acc90"
    v_key_name = "sep-27"
    v_az = module.my_network.v_az
    v_sg_web = module.my_sg_webserver.v_sg_web
    v_sn1 = module.my_network.v_sn1
}