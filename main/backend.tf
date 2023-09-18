terraform {
  backend "s3" {
    bucket = "my-terraform-values"
    key    = "my-terraform-values/terraform-eks-statefile/"
    region = "us-east-1"
	role_arn ="arn:aws:iam::676759655484:role/terraform-eks-s3"
  }
}
