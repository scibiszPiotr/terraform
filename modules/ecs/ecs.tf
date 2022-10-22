resource "aws_ecs_cluster" "pscibisz-ecs" {
  name = "pscibisz-cluster-ecs"
}

resource "aws_ecs_service" "db-app" {
  name            = "db-app"
  cluster         = aws_ecs_cluster.pscibisz-ecs.id
  task_definition = aws_ecs_task_definition.definition-app-db.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [
      var.sg_http_id,
      var.sg_mysql_id
    ]
    subnets = [for s in var.private_subnets : s.id]
  }

  load_balancer {
    target_group_arn = var.tg[1].arn
    container_name   = "app"
    container_port   = 80
  }
}

resource "aws_ecs_service" "s3-app" {
  name            = "s3-app"
  cluster         = aws_ecs_cluster.pscibisz-ecs.id
  task_definition = aws_ecs_task_definition.definition-app-s3.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [
      var.sg_http_id
    ]
    subnets = [for s in var.private_subnets : s.id]
  }

  load_balancer {
    target_group_arn = var.tg[0].arn
    container_name   = "app"
    container_port   = 80
  }
}