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
}
variable "vpc_id" {
  description = "EC2インスタンスを配置する対象のVPCのID"
  type        = string
}
variable "alb_sg_id" {
  description = "ALBからの通信を許可するためにEC2に設定するセキュリティグループID"
  type        = string
}

variable "rds_endpoint" {
  description = "接続先RDSのエンドポイント（例: mydb.xxxxxx.ap-northeast-1.rds.amazonaws.com）"
  type        = string
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