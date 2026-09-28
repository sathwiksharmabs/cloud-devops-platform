resource "aws_ecr_repository" "app" {
  name                 = "${var.environment}/cloud-devops-platform"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-cloud-devops-platform"
    Environment = var.environment
  }
}
