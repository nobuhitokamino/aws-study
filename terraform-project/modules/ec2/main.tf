# data "aws_ami" "amazon_linux" {

#   most_recent = true

#   owners = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-*-x86_64"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

# }
# ############################
# # Security Group
# ############################

# resource "aws_security_group" "web_sg" {

#   name   = "web-sg"
#   vpc_id = var.vpc_id

#   ingress {

#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     cidr_blocks = [var.my_ip]

#   }

#   ingress {

#     from_port       = 8080
#     to_port         = 8080
#     protocol        = "tcp"
#     security_groups = [var.alb_sg_id]

#   }

#   egress {

#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }
# }

# ###########################
# # EC2
# ###########################

# resource "aws_instance" "web" {

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = var.instance_type

#   subnet_id = var.public_subnet_id
#   key_name  = var.key_name

#   vpc_security_group_ids = [
#     aws_security_group.web_sg.id
#   ]

#   user_data = templatefile("${path.module}/userdata.sh", {
#     rds_endpoint = var.rds_endpoint
#     db_username  = var.db_username
#     db_password  = var.db_password
#   })

#   tags = {
#     Name = "terraform-ec2"
#   }

# }