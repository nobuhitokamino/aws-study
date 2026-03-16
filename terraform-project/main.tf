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

###########################
# EC2 SecurityGroup
###########################
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

################################
# EC2 Module
################################

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
  source = "./modules/alb"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  # instance_id = module.ec2.instance_id
  asg_name = module.asg.asg_name
}
####################
# ALB Attachment
####################

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

  resource_arn = module.alb.alb_arn
}

#######################
# CloudWatch Module
#######################
module "cloudwatch" {
  source = "./modules/cloudwatch"

  # instance_id        = module.ec2.instance_id
  asg_name           = module.asg.asg_name
  notification_email = var.notification_email
}