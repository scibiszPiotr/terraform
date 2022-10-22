data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "pscibiszEcsTaskExecutionRole"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role" "ecs_task_role-s3" {
  name = "pscibiszRoleNameTaskS3"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role" "ecs_task_role-db" {
  name = "pscibiszRoleNameTaskDb"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_s3" {
  role       = aws_iam_role.ecs_task_role-s3.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "task_db" {
  role       = aws_iam_role.ecs_task_role-db.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
