output "uploads_bucket_name" {
  description = "Name of the uploads bucket"
  value       = aws_s3_bucket.uploads.bucket
}

output "uploads_bucket_arn" {
  description = "ARN of the uploads bucket"
  value       = aws_s3_bucket.uploads.arn
}

output "results_bucket_name" {
  description = "Name of the results bucket"
  value       = aws_s3_bucket.results.bucket
}

output "results_bucket_arn" {
  description = "ARN of the results bucket"
  value       = aws_s3_bucket.results.arn
}