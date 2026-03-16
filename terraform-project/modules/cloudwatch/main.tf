######################
#SNS Topic
######################
resource "aws_sns_topic" "study_topic" {
  name = "study-topic"
}
#######################
# メール購読
#######################

resource "aws_sns_topic_subscription" "terra_subsc" {
  topic_arn = aws_sns_topic.study_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

############################
# CloudWatch alarm
############################
resource "aws_cloudwatch_metric_alarm" "terra_alarm" {
  alarm_name          = "terraform-test-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  treat_missing_data  = "missing"
  # insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [
    aws_sns_topic.study_topic.arn
  ]
}
########################
# CloudWatch DashBoard
########################
data "aws_region" "current" {}
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              # "InstanceId",
              # var.instance_id
              "AutoScalingGroupName",
              var.asg_name
            ]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.id
          title  = "EC2 Instance CPU"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/WAFV2",
              "BlockedRequests",
              "WebACL",
              "aws-study-acl",
              "Rule",
              "ALL",
            ]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.id
          title  = "WAF Blocked Requests"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6

        properties = {
          region = data.aws_region.current.id
          title  = "WAF Logs"

          # logGroupNames = [
          #   "aws-waf-logs-sample-webacl"
          # ]
          # queryString = "fields @timestamp, action, httpRequest.clientIp, httpRequest.uri | sort @timestamp desc | limit 20"

          query = "SOURCE 'aws-waf-logs-sample-webacl' | fields @timestamp, action, httpRequest.clientIp, httpRequest.uri | sort @timestamp desc | limit 20"

          view = "table"
        }
      }
    ]
  })
}