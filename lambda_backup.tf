data "archive_file" "lambda_backup_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/ec2_backup.py"
  output_path = "${path.module}/lambda/ec2_backup.zip"
}

resource "aws_lambda_function" "ec2_backup_lambda" {
  function_name    = "ec2-backup-lambda"
  filename         = data.archive_file.lambda_backup_zip.output_path
  handler          = "ec2_backup.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_backup_zip.output_base64sha256
  role             = aws_iam_role.lambda_backup_role.arn
  timeout          = 30
}
