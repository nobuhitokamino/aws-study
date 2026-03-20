variable "region" {
  description = "AWSリソースを作成するリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック（例: 10.0.0.0/16）"
  type        = string
}

variable "public_subnets" {
  description = "パブリックサブネットの定義（CIDRとAZのマップ）"
  type = map(object({
    cidr = string # サブネットのCIDR（例: 10.0.1.0/24）
    az   = string # 配置するアベイラビリティゾーン（例: ap-northeast-1a）
  }))
}

variable "private_subnets" {
  description = "プライベートサブネットの定義（CIDRとAZのマップ）"
  type = map(object({
    cidr = string # サブネットのCIDR（例: 10.0.2.0/24）
    az   = string # 配置するアベイラビリティゾーン（例: ap-northeast-1c）
  }))

}

variable "my_ip" {
  description = "SSH接続を許可する自身のグローバルIPアドレス（例: 1.2.3.4/32）"
  type        = string
}

variable "key_name" {
  description = "EC2インスタンスに設定するキーペア名（SSH接続用）"
  type        = string
}

variable "instance_type" {
  description = "EC2インスタンスのタイプ（例: t3.micro）"
  type        = string
  default     = "t3.micro"
}

variable "db_username" {
  description = "RDSデータベースのマスターユーザー名"
  type        = string
}

variable "db_password" {
  description = "RDSデータベースのマスターパスワード（機密情報のため安全に管理すること）"
  type        = string
  sensitive   = true
}

variable "notification_email" {
  description = "CloudWatchアラーム通知を受信するメールアドレス"
  type        = string
}

variable "alb_name" {
  description = "作成するALBの名前"
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