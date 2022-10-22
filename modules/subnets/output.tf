output "public_subnets" {
  value = aws_subnet.public_subnet
}

output "private_subnets" {
  value = aws_subnet.private_subnet
}

output "vpc_id" {
  value = aws_vpc.pscibisz-terraform.id
}