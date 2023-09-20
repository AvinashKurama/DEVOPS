resource "aws_eks_cluster" "dev_cluster" {
  name     = "dev_cluster"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = concat(aws_subnet.pub-sn1.*.id)
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly-EKS,
  ]

   tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_iam_role" "cluster_role" {
  name = "cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
	role    = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.cluster_role.name
}



