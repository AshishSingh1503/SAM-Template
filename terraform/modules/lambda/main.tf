data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../src"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "start_textract" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-start-textract-${var.environment}"
  role            = var.lambda_execution_role
  handler         = "start_textract_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.12"
  timeout         = 60
  memory_size     = 256
  reserved_concurrent_executions = 10

  tracing_config {
    mode = "Active"
  }

  dead_letter_config {
    target_arn = var.start_textract_dlq_arn
  }

  environment {
    variables = {
      ENVIRONMENT     = var.environment
      LOG_LEVEL      = "INFO"
      SNS_TOPIC_ARN  = var.sns_topic_arn
      IAM_ROLE_ARN   = var.textract_service_role
    }
  }
}

resource "aws_lambda_function" "process_results" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-process-results-${var.environment}"
  role            = var.lambda_execution_role
  handler         = "process_results_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 512
  reserved_concurrent_executions = 5

  tracing_config {
    mode = "Active"
  }

  dead_letter_config {
    target_arn = var.process_results_dlq_arn
  }

  environment {
    variables = {
      ENVIRONMENT     = var.environment
      LOG_LEVEL      = "INFO"
      RESULTS_BUCKET = var.results_bucket_name
      RESULTS_PREFIX = "processed/"
    }
  }
}

resource "aws_s3_bucket_notification" "uploads_notification" {
  bucket = var.uploads_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.start_textract.arn
    events             = ["s3:ObjectCreated:*"]
    filter_suffix      = ".pdf"
  }

  depends_on = [aws_lambda_permission.s3_invoke_start_textract]
}

resource "aws_lambda_permission" "s3_invoke_start_textract" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_textract.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.uploads_bucket_name}"
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn                   = var.textract_queue_arn
  function_name                      = aws_lambda_function.process_results.arn
  batch_size                         = 1
  maximum_batching_window_in_seconds = 5
}