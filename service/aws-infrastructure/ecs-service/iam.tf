# Task execution role
resource "aws_iam_role" "task_exec" {
  name = "lang-rec-task-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Principal = {
          Service = ["ecs-tasks.amazonaws.com"]
        }
      }
    ]
  })
  tags = {
    Name    = "lang-rec-task-exec"
    Project = var.project
  }
}

resource "aws_iam_policy" "task_exec" {
  name        = "task-execution-policy"
  description = "Allows task execution for ECS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_exec_attach" {
  policy_arn = aws_iam_policy.task_exec.arn
  role       = aws_iam_role.task_exec.name
}
