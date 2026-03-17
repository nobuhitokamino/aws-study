variable "notification_email" {
  description = "CloudWatchアラーム通知を受信するメールアドレス（SNSトピックの購読先）"
  type        = string
}
variable "dashboard_name" {
  description = "作成するCloudWatchダッシュボードの名前"
  type        = string
  default     = "aws-study-dashboard"
}
# EC2モジュールを使うときに使用
# variable "instance_id" {
#   type = string
# }
variable "asg_name" {
  description = "監視対象のAuto Scaling Group名（CPUUtilizationのメトリクス取得に使用）"
  type        = string
}
variable "waf_name" {
  description = "監視対象のWAF WebACL名（BlockedRequestsメトリクスで使用）"
  type        = string
}
variable "waf_log_group_name" {
  description = "WAFログのCloudWatch Logsグループ名"
  type        = string
}
variable "alarm_name" {
  description = "CloudWatchアラームの名前"
  type        = string
}
