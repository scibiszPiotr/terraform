
output "this_db_name" {
  value = aws_db_instance.rds.db_name
}

output "this_db_instance_address" {
  value = aws_db_instance.rds.address
}

output "this_db_instance_arn" {
  value = aws_db_instance.rds.arn
}

output "this_db_instance_domain" {
  value = aws_db_instance.rds.domain
}

output "this_db_instance_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "this_db_instance_status" {
  value = aws_db_instance.rds.status
}

output "password" {
  value = aws_db_instance.rds.password
}

output "address" {
  value = aws_db_instance.rds.address
}