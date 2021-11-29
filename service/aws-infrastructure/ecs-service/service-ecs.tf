
resource "aws_ecs_task_definition" "langrec_def" {
  family                   = var.project
  execution_role_arn       = aws_iam_role.task_exec.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name  = "${var.project}-service-run"
      image = "${data.terraform_remote_state.ecr_data.outputs.ecr_url}:${var.img_tag}"
      portMappings = [
        {
          hostPort      = 80
          containerPort = 80
        }
      ]
    }
  ])
  tags = {
    Name        = var.project
    Description = "Task definition for language recognize service."
    Project     = var.project
  }
}

resource "aws_ecs_service" "language_recognize" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.language_recognize.arn
  task_definition = aws_ecs_task_definition.langrec_def.arn
  desired_count   = "1"
  network_configuration {
    subnets          = [var.subnet_id]
    assign_public_ip = true
    security_groups  = [aws_security_group.http_access.id]
  }
  tags = {
    Name    = var.project
    Project = var.project
  }
}
