output "start_textract_function_name" {
  description = "Name of the start Textract function"
  value       = aws_lambda_function.start_textract.function_name
}

output "process_results_function_name" {
  description = "Name of the process results function"
  value       = aws_lambda_function.process_results.function_name
}