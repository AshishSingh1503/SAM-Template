variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_execution_role" {
  description = "ARN of the Lambda execution role"
  type        = string
}

variable "textract_service_role" {
  description = "ARN of the Textract service role"
  type        = string
}

variable "uploads_bucket_name" {
  description = "Name of the uploads bucket"
  type        = string
}

variable "results_bucket_name" {
  description = "Name of the results bucket"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "textract_queue_arn" {
  description = "ARN of the Textract SQS queue"
  type        = string
}

variable "start_textract_dlq_arn" {
  description = "ARN of the start Textract DLQ"
  type        = string
}

variable "process_results_dlq_arn" {
  description = "ARN of the process results DLQ"
  type        = string
}