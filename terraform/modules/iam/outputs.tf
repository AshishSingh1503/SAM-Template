output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.arn
}

output "textract_service_role_arn" {
  description = "ARN of the Textract service role"
  value       = aws_iam_role.textract_service.arn
}