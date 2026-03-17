vpc_cidr = "10.0.0.0/16"

my_ip = "221.12.250.105/32"

key_name = "dev-raisetech-kypr-tokyo"

public_subnets = {
  public_a = {
    cidr = "10.0.1.0/24"
    az   = "ap-northeast-1a"
  }

  public_c = {
    cidr = "10.0.2.0/24"
    az   = "ap-northeast-1c"
  }
}

private_subnets = {

  private_a = {
    cidr = "10.0.3.0/24"
    az   = "ap-northeast-1a"
  }

  private_c = {
    cidr = "10.0.4.0/24"
    az   = "ap-northeast-1c"
  }
}
db_username = "root"
db_password = "nB59SGqLbFUlD4eh"

notification_email = "05clvd43ax@gmail.com"

alb_name = "terra-alb"

waf_name = "aws-study-acl"

waf_log_group_name = "aws-waf-logs-sample-webacl"

alarm_name = "terraform-test-alarm"