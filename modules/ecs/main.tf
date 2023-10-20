resource "aws_ecs_cluster" "ecs" {
  name               = "ecs-fargate"
  capacity_providers = ["FARGATE"]
  tags               = var.tags
}

data "template_file" "container_definitions" {
  template = file("${path.module}/templates/task-definition.json.tpl")

  vars = {
    name                                   = "${var.name_prefix}-controller"
    
  }
}

resource "aws_cloudwatch_log_group" jenkins_controller_log_group {
  name              = var.name_prefix
  retention_in_days = var.cloudwatch_retention_days
  tags              = var.tags
}

resource "aws_ecs_task_definition" "task-definition" {
  family = var.name_prefix

  task_role_arn            = var.jenkins_controller_task_role_arn != null ? var.jenkins_controller_task_role_arn : aws_iam_role.jenkins_controller_task_role.arn
  execution_role_arn       = var.ecs_execution_role_arn != null ? var.ecs_execution_role_arn : aws_iam_role.jenkins_controller_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.jenkins_controller_cpu
  memory                   = var.jenkins_controller_memory
  container_definitions    = data.template_file.container_definitions.rendered
  tags = var.tags
}


resource "aws_ecs_service" "ecs-service" {
  name = "service"

  task_definition  = aws_ecs_task_definition.task-definition.arn
  cluster          = aws_ecs_cluster.ecs.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  // Assuming we cannot have more than one instance at a time. Ever. 
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  
}
