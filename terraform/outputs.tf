output "uploads_bucket_name" {
  description = "Name of the uploads S3 bucket"
  value       = module.s3.uploads_bucket_name
}

output "results_bucket_name" {
  description = "Name of the results S3 bucket"
  value       = module.s3.results_bucket_name
}

output "start_textract_function_name" {
  description = "Name of the start textract Lambda function"
  value       = module.lambda.start_textract_function_name
}

output "process_results_function_name" {
  description = "Name of the process results Lambda function"
  value       = module.lambda.process_results_function_name
}