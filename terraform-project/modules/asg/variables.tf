variable "target_group_arn" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "rds_endpoint" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "key_name" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "security_group_id" {
  type = string
}