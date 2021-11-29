
resource "aws_ecr_repository" "language_recognize" {
  name                 = "language-recognize"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "language-recognize"
    Description = "Repository for Language Recognize service Docker images"
    Project     = "language-recognize"
  }
}
