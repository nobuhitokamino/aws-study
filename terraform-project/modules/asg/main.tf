#####################
# AMI 設定
#####################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

########################
# Launch Template
########################
resource "aws_launch_template" "app" {

  name_prefix   = "springboot-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    rds_endpoint = var.rds_endpoint
    db_username  = var.db_username
    db_password  = var.db_password
  }))

}
#########################
# AutoScalingGroup
#########################
resource "aws_autoscaling_group" "app" {

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "springboot"
    propagate_at_launch = true
  }

}