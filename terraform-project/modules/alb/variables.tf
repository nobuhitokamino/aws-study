variable "subnet_ids" {
  description = "ALBを配置するサブネットIDのリスト（通常はパブリックサブネット）"
  type        = list(string)
}
variable "vpc_id" {
  description = "ALBを作成する対象のVPCのID"
  type        = string
}
variable "alb_name" {
  description = "作成するALBの名前"
  type        = string
}

variable "listener_port" {
  description = "ALBリスナーのポート番号"
  type        = number
  default     = 80
}

variable "target_port" {
  description = "ターゲットグループのポート番号（アプリケーション側）"
  type        = number
  default     = 8080
}
# EC2モジュールで作成する時にALB Attachmentで使用
# variable "instance_id" {
#   type = string
# }