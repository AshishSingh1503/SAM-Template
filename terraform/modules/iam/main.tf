data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "textract_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["textract.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution" {
  name               = "${var.project_name}-lambda-execution-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "textract_service" {
  name               = "${var.project_name}-textract-service-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.textract_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_xray" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

data "aws_iam_policy_document" "lambda_s3_textract" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["${var.uploads_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${var.results_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "textract:StartDocumentAnalysis",
      "textract:StartDocumentTextDetection",
      "textract:GetDocumentAnalysis",
      "textract:GetDocumentTextDetection"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [var.textract_queue_arn]
  }
}

resource "aws_iam_role_policy" "lambda_s3_textract" {
  name   = "${var.project_name}-lambda-policy-${var.environment}"
  role   = aws_iam_role.lambda_execution.id
  policy = data.aws_iam_policy_document.lambda_s3_textract.json
}

data "aws_iam_policy_document" "textract_sns" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [var.sns_topic_arn]
  }
}

resource "aws_iam_role_policy" "textract_sns" {
  name   = "${var.project_name}-textract-sns-${var.environment}"
  role   = aws_iam_role.textract_service.id
  policy = data.aws_iam_policy_document.textract_sns.json
}