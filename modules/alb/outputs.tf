output "target_group_name" {
  value = aws_lb_target_group.followme_tg.name
}

output "dns_name" {
  value = aws_lb.followme_alb.dns_name
}

output "zone_id" {
  value = aws_lb.followme_alb.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.followme_tg.arn
}
