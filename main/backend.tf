terraform {
  backend "s3" {
    bucket = "my-terraform-values"
    key    = "terraform-state/tf.statefile"
    region = "us-east-1"
    role_arn ="arn:aws:iam::676759655484:role/my-terra-value"
  }
}
