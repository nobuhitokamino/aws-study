variable "target_group_arn" {
  description = "Auto Scaling Groupを関連付けるALBのターゲットグループARN"
  type        = string
}
variable "public_subnet_ids" {
  description = "EC2インスタンスを配置するサブネットIDのリスト（通常はパブリックサブネットまたはプライベートサブネット）"
  type        = list(string)
}
variable "rds_endpoint" {
  description = "接続先RDSのエンドポイント（例: mydb.xxxxxx.ap-northeast-1.rds.amazonaws.com）"
  type        = string
}
variable "db_username" {
  description = "RDSデータベースに接続するユーザー名"
  type        = string
}
variable "db_password" {
  description = "RDSデータベースに接続するパスワード（機密情報のため安全に管理すること）"
  type        = string
  sensitive   = true
}
variable "key_name" {
  description = "EC2インスタンスに設定するキーペア名（SSH接続用）"
  type        = string
}
variable "instance_type" {
  description = "起動するEC2インスタンスのタイプ（例: t3.micro）"
  type        = string
  default     = "t3.micro"
}
variable "security_group_id" {
  description = "EC2インスタンスに関連付けるセキュリティグループID"
  type        = string
}