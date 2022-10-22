variable "vpc_id" {}

variable "sg_mysql" {}

variable "networks" {
}

variable "db-password" {
  default = "wojtek11"
}

variable "db-user" {
  default = "admin"
}

variable "db-name" {
  default = "db_app"
}

variable "sg-to-connect" {
  default = "pscibisz-mysql-allowed-private"
}