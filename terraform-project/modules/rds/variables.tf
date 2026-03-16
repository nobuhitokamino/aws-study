variable "private_subnet_ids" {
  type = list(string)
}


variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}
variable "web_sg_id" {
  type = string
}
variable "vpc_id" {
  type = string
}