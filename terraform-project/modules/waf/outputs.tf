output "web_acl_name" {
  value = aws_wafv2_web_acl.aws_study_acl.name
}
output "waf_log_group_name" {
  value = aws_wafv2_web_acl.aws_study_acl.name

}