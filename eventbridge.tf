resource "aws_cloudwatch_event_rule" "ec2_backup_schedule" {
  name                = "ec2-backup-daily"
  schedule_expression = "cron(0 15 * * ? *)"  # UTC 기준 15시 = 한국 자정
  # schedule_expression = "cron(0/10 * * * ? *)"  # 매 5분마다 실행
}

resource "aws_cloudwatch_event_target" "lambda_trigger" {
  rule      = aws_cloudwatch_event_rule.ec2_backup_schedule.name
  target_id = "lambda"
  arn       = aws_lambda_function.ec2_backup_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_backup_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_backup_schedule.arn
}
