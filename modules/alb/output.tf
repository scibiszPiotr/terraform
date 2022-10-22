output "tg" {
  value = aws_alb_target_group.pscibisz-tg
}

output "alb_dns_name" {
  value = aws_alb.pscibisz-alb.dns_name
}

#output "new_target_groups" {
#  value = { for target_group in aws_alb_target_group.pscibisz-tg : target_group.name => target_group.arn }
#}