terraform {
  backend "s3" {
    bucket = "my-bucket-${module.my-vpc1.vpc1}"
    key    = "terraform-eks-statefile/tf.statefile"
    region = "us-east-1"
	role_arn = aws_iam_role.terraform_backend_role.arn
  depends_on = aws_s3_bucket.states3.id
  }
}


resource "aws_s3_bucket" "states3" {
  bucket = "my-bucket-${module.my-vpc1.vpc1}"

  tags = {
    Name        = "my-bucket-${module.my-vpc1.vpc1}"
    Environment = "Dev"
  }
}

resource "aws_iam_role" "terraform_backend_role" {
  name = "terraform-eks-backend-role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3_backend_policy" {
  name        = "s3-backend-policy"
  description = "IAM policy for Terraform S3 backend access"
  
  # Define the policy document that grants access to the specific S3 bucket
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::my-bucket-${module.my-vpc1.vpc1}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "arn:aws:s3:::my-bucket-${module.my-vpc1.vpc1}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_backend_attachment" {
  policy_arn = aws_iam_policy.s3_backend_policy.arn
  role       = aws_iam_role.terraform_backend_role.name
}

output "role_arn" {
  value = aws_iam_role.terraform_backend_role.arn
}
