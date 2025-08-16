variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "uploads_bucket_arn" {
  description = "ARN of the uploads bucket"
  type        = string
}

variable "results_bucket_arn" {
  description = "ARN of the results bucket"
  type        = string
}

variable "textract_queue_arn" {
  description = "ARN of the Textract SQS queue"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}