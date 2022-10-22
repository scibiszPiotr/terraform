output "pscibiszEcsTaskExecutionRole-id" {
  value = aws_iam_role.ecs_task_execution_role.id
}

output "pscibiszRoleNameTaskDb-id" {
  value = aws_iam_role.ecs_task_role-db.id
}

output "pscibiszRoleNameTaskS3-id" {
  value = aws_iam_role.ecs_task_role-s3.id
}

output "pscibiszEcsTaskExecutionRole-arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "pscibiszRoleNameTaskDb-arn" {
  value = aws_iam_role.ecs_task_role-db.arn
}

output "pscibiszRoleNameTaskS3-arn" {
  value = aws_iam_role.ecs_task_role-s3.arn
}
