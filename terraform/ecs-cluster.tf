resource "aws_ecs_task_definition" "nx_task" {
  family                   = "nx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "4096"  # 4 vCPUs
  memory                   = "8192"  # 8 GB RAM

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "nx-app-container"
      image = "your-docker-image:latest"  # Replace with your Docker image
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      essential = true
    }
  ])
}
