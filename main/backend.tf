terraform {
  backend "s3" {
    bucket         = "kurama-s3-bucket"
    key            = "statefile/terraform.tfstate"     # Path to your state file within the bucket
    region         = "us-east-1"                       # AWS region where the bucket is located  
    role_arn       = "arn:aws:iam::154836231234:role/terraform-s3"
  }
}
