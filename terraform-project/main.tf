provider "aws" {
  region = var.region
}

################################
# VPC Module
################################

module "vpc" {

  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}

###########################################
# EC2 SecurityGroup ASGモジュール作成時に使用
###########################################
resource "aws_security_group" "ec2_sg" {

  name   = "ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [module.alb.alb_sg_id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# RDS Module
############################
module "rds" {

  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  web_sg_id = aws_security_group.ec2_sg.id

  # EC2モジュールで作成するときに使用
  # web_sg_id = module.ec2.web_sg_id

  db_username = var.db_username
  db_password = var.db_password

}

############################
# ASG Module
############################

module "asg" {
  source = "./modules/asg"

  public_subnet_ids = module.vpc.public_subnet_ids

  target_group_arn = module.alb.target_group_arn

  rds_endpoint      = module.rds.endpoint
  db_username       = var.db_username
  db_password       = var.db_password
  security_group_id = aws_security_group.ec2_sg.id

  key_name = var.key_name

}

##################################
# EC2 Module でEC2作成するときに使用
##################################

# module "ec2" {

#   source = "./modules/ec2"

#   vpc_id           = module.vpc.vpc_id
#   public_subnet_id = module.vpc.public_subnet_ids[0]

#   rds_endpoint  = module.rds.endpoint
#   alb_sg_id     = module.alb.alb_sg_id
#   my_ip         = var.my_ip
#   key_name      = var.key_name
#   instance_type = var.instance_type
#   db_username   = var.db_username
#   db_password   = var.db_password
# }

######################
# ALB Module
######################
module "alb" {
  source     = "./modules/alb"
  alb_name   = var.alb_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  # EC2モジュールで作成するときに使用
  # instance_id = module.ec2.instance_id

}
##############################################
# ALB Attachment EC2モジュールで作成するときに使用
##############################################

# resource "aws_lb_target_group_attachment" "alb_tg" {

#   target_group_arn = module.alb.target_group_arn
#   target_id        = module.ec2.instance_id
#   port             = 8080
# }

######################
# WAF Module
######################
module "waf" {
  source = "./modules/waf"

  resource_arn       = module.alb.alb_arn
  waf_name           = var.waf_name
  waf_log_group_name = var.waf_log_group_name
}

#######################
# CloudWatch Module
#######################
module "cloudwatch" {
  source = "./modules/cloudwatch"

  # EC2モジュールで作成時に使用
  # instance_id        = module.ec2.instance_id
  asg_name           = module.asg.asg_name
  notification_email = var.notification_email
  alarm_name         = var.alb_name
  waf_name           = module.waf.web_acl_name
  waf_log_group_name = module.waf.waf_log_group_name
}