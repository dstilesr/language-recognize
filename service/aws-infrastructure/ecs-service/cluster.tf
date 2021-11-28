resource "aws_ecs_cluster" "language_recognize" {
  name               = "language-recognize-cluster"
  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
  tags = {
    Name        = "language-recognize-cluster"
    Description = "Cluster to run the Language Recognition service on Fargate"
  }
}