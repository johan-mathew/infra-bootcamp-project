
resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.TAG_PREFIX}-to-do"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

