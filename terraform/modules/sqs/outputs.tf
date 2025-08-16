output "textract_queue_arn" {
  description = "ARN of the Textract results queue"
  value       = aws_sqs_queue.textract_results.arn
}

output "start_textract_dlq_arn" {
  description = "ARN of the start Textract DLQ"
  value       = aws_sqs_queue.start_textract_dlq.arn
}

output "process_results_dlq_arn" {
  description = "ARN of the process results DLQ"
  value       = aws_sqs_queue.process_results_dlq.arn
}