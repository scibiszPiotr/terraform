output "SG-allow-SSH-id" {
  value = aws_security_group.pscibisz-ssh-allowed-public.id
}

output "SG-allow-HTTP-id" {
  value = aws_security_group.pscibisz-http-allowed-public.id
}

output "SG-allow-MySQL-id" {
  value = aws_security_group.pscibisz-mysql-allowed-private.id
}
