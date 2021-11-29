output "ecr_url" {
  value = aws_ecr_repository.language_recognize.repository_url
}

output "ecr_registry_id" {
  value = aws_ecr_repository.language_recognize.registry_id
}
