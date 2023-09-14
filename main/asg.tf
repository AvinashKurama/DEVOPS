module "my-asg" {

  source        = "../modules/asg"
  image_id      = "ami-053b0d53c279acc90"
  sg_webser-1     = module.my-sg.sg_webser-1
  v_targetgroup1 = module.my-elb.v_targetgroup1
  instance_type = "t2.micro"
  v_sn1         = module.my-network.v_sn1
  desired       = 2
  min           = 1
  max           = 3
}
 