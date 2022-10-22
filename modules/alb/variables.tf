variable "public_subnets" {}
variable "private_subnets" {}
variable "vpc_id" {}
variable "sg_http_id" {}

variable "listeners" {
  default = [
    {
      id: 101,
      name: "s3"
    },
    {
      id: 102,
      name: "db"
    }
  ]
}