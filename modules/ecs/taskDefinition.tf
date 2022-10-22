resource "aws_ecs_task_definition" "definition-app-db" {
  family                   = "terraform-pscibisz-db-app"
  task_role_arn            = var.pscibiszRoleNameTaskDb-arn
  execution_role_arn       = var.pscibiszEcsTaskExecutionRole-arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode(
    [
      {
        "name" : "app",
        "image" : "890769921003.dkr.ecr.eu-central-1.amazonaws.com/pscibisz-db:${var.APP_DB_TAG}",
        "portMappings" : [
          {
            "containerPort" : 80,
            "hostPort" : 80,
            "protocol" : "tcp"
          }
        ],
        "environment" : [
          {
            "name" : "DB_HOST",
            "value" : "${var.rds_address}"
          },
          {
            "name" : "WEBROOT",
            "value" : "/var/www/html/public"
          },
          {
            "name" : "DB_PASSWORD",
            "value" : "${var.rds_password}"
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-create-group" : "true",
            "awslogs-group" : "/ecs/app-db",
            "awslogs-region" : "eu-central-1",
            "awslogs-stream-prefix" : "ecs"
          }
        }
      }
    ]
  )
}

resource "aws_ecs_task_definition" "definition-app-s3" {
  family                   = "terraform-pscibisz-s3-app"
  task_role_arn            = var.pscibiszRoleNameTaskS3-arn
  execution_role_arn       = var.pscibiszEcsTaskExecutionRole-arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode(
    [
      {
        "name" : "app",
        "image" : "890769921003.dkr.ecr.eu-central-1.amazonaws.com/pscibisz-web-s3:${var.APP_S3_TAG}",
        "portMappings" : [
          {
            "containerPort" : 80,
            "hostPort" : 80,
            "protocol" : "tcp"
          }
        ],
        "environment" : [
          {
            "name" : "WEBROOT",
            "value" : "/var/www/html/public"
          },
          {
            "name" : "URL_APP_DB",
            "value" : "${var.alb_dns_name}/db"
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-create-group" : "true",
            "awslogs-group" : "/ecs/app-db",
            "awslogs-region" : "eu-central-1",
            "awslogs-stream-prefix" : "ecs"
          }
        }
      }
    ]
  )
}