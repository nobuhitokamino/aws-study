variable "resource_arn" {
  description = "WAF WebACLを関連付ける対象リソースのARN（例: ALBのARN）"
  type        = string
}
variable "waf_name" {
  description = "作成するWAF WebACLの名前（CloudWatchメトリクスの識別にも使用される）"
  type        = string
}
variable "waf_log_group_name" {
  description = "WAFログを出力するCloudWatch Logsのロググループ名（例: aws-waf-logs-xxxx）"
  type        = string
}
