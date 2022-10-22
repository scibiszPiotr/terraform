variable "vpc_id" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "sg_http_id" {}
variable "sg_mysql_id" {}
variable "tg" {}

variable "rds_address" {}
variable "rds_password" {}
variable "alb_dns_name" {}

variable "pscibiszEcsTaskExecutionRole-arn" {}
variable "pscibiszRoleNameTaskDb-arn" {}
variable "pscibiszRoleNameTaskS3-arn" {}

variable "APP_DB_TAG" {}
variable "APP_S3_TAG" {}