resource "aws_ecr_repository" "my_eks_ecr" {
  name                 = "eks_images"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}