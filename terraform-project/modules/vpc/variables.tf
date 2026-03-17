variable "vpc_cidr" {
  description = "VPC全体に割り当てるCIDRブロック（例: 10.0.0.0/16）"
  type        = string
}

variable "public_subnets" {
  description = "インターネット接続用のパブリックサブネット定義（キー名任意、CIDRとAZを指定）"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "アプリケーションやデータベース用のプライベートサブネット定義（キー名任意、CIDRとAZを指定）"
  type = map(object({
    cidr = string
    az   = string
  }))
}
