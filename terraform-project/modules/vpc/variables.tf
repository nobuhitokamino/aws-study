variable "vpc_cidr" {
  type = string
}
variable "vpc_id" {
  type = string
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
