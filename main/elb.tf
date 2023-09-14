module "my-elb" {
  source              = "../modules/elb"
  sg_alb-1            = module.my-sg.sg_alb-1
  v_vpc1              = module.my-network.v_vpc1
  v_sn1               = module.my-network.v_sn1
  v_targetgroup1      = module.my-elb.v_targetgroup1
  port                = 80
  protocol            = "HTTP"
  interval            = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3
}