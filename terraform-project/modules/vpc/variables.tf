variable "vpc_cidr" {
  type = string
}
variable "vpc_id" {
  description = "既存のVPCを使う場合のみ使用"
  type        = string
  default     = null
}
variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}
