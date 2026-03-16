output "alb_sg_id" {

  value = aws_security_group.alb_sg.id

}
output "alb_dns_name" {
  value = aws_lb.alb_terra.dns_name
}
output "alb_arn" {
  value = aws_lb.alb_terra.arn
}
output "target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}