variable "private_subnet_ids" {
  description = "RDSインスタンスを配置するプライベートサブネットのIDリスト（マルチAZ構成のため複数指定推奨）"
  type        = list(string)
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

variable "web_sg_id" {
  description = "アプリケーション（EC2）からの接続を許可するためのセキュリティグループID"
  type        = string
}

variable "vpc_id" {
  description = "RDSインスタンスを配置する対象のVPCのID"
  type        = string
}