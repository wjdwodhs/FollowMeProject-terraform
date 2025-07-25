output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}
