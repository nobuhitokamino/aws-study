variable "region" {
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
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

# variable "subnet_id" {
#   description = "Subnet settings"
#   type = map(object({
#     cidr = string
#     az   = string
#   }))
# }

variable "my_ip" {
  description = "My IP address for SSH access"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}
variable "notification_email" {
  type = string
}