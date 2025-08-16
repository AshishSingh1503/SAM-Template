resource "aws_sqs_queue" "textract_results" {
  name                       = "${var.project_name}-textract-results-${var.environment}"
  visibility_timeout_seconds = 360
  message_retention_seconds  = 1209600
  kms_master_key_id         = "alias/aws/sqs"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.textract_dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "textract_dlq" {
  name                      = "${var.project_name}-textract-dlq-${var.environment}"
  message_retention_seconds = 1209600
  kms_master_key_id        = "alias/aws/sqs"
}

resource "aws_sqs_queue" "start_textract_dlq" {
  name                      = "${var.project_name}-start-textract-dlq-${var.environment}"
  message_retention_seconds = 1209600
  kms_master_key_id        = "alias/aws/sqs"
}

resource "aws_sqs_queue" "process_results_dlq" {
  name                      = "${var.project_name}-process-results-dlq-${var.environment}"
  message_retention_seconds = 1209600
  kms_master_key_id        = "alias/aws/sqs"
}

data "aws_iam_policy_document" "sns_to_sqs" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.textract_results.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.sns_topic_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sns_to_sqs" {
  queue_url = aws_sqs_queue.textract_results.id
  policy    = data.aws_iam_policy_document.sns_to_sqs.json
}

resource "aws_sns_topic_subscription" "textract_results" {
  topic_arn = var.sns_topic_arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.textract_results.arn
}