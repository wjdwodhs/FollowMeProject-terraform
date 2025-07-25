# SNS
resource "aws_sns_topic" "this" {
  name = "ec2-monitoring-alert"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.email_address
}

# Lambda Package (zip)
data "archive_file" "lambda_backup_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/ec2_backup.py"
  output_path = "${path.module}/lambda/ec2_backup.zip"
}

# Lambda Function
resource "aws_lambda_function" "this" {
  function_name    = "ec2-backup-lambda"
  filename         = data.archive_file.lambda_backup_zip.output_path
  handler          = "ec2_backup.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_backup_zip.output_base64sha256
  role             = var.lambda_role_arn
  timeout          = 30
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "this" {
  name                = "ec2-backup-daily"
  schedule_expression = "cron(0 15 * * ? *)"
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "lambda"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
