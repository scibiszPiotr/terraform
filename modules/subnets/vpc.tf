resource "aws_vpc" "pscibisz-terraform" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "pscibisz-terraform"
  }
}