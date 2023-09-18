terraform {
  backend "s3" {
    bucket = "my-terraform-values"
    key    = "terraform-eks-statefile/tf.statefile"
    region = "us-east-1"
	role_arn ="arn:aws:iam::676759655484:role/terraform-eks-s3"
  }
}
