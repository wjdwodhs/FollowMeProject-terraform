resource "aws_sns_topic" "alert_topic" {
  name = "ec2-monitoring-alert"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = "wjdwodhs@naver.com" 
}
