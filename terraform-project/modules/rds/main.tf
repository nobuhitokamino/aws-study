####################3
# subnet group
####################
resource "aws_db_subnet_group" "rds_subnet_group" {

  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

}
###################
# security group
###################
resource "aws_security_group" "rds_sg" {

  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.web_sg_id]

  }
}
###################
# RDS
###################

resource "aws_db_instance" "tf_rds" {

  identifier = "terraform-rds"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = "awsstudy"
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot = true

}