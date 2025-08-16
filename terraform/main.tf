terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# S3 Buckets
module "s3" {
  source = "./modules/s3"
  
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}

# IAM Roles
module "iam" {
  source = "./modules/iam"
  
  project_name         = var.project_name
  environment          = var.environment
  uploads_bucket_arn   = module.s3.uploads_bucket_arn
  results_bucket_arn   = module.s3.results_bucket_arn
  textract_queue_arn   = module.sqs.textract_queue_arn
  sns_topic_arn        = module.sns.topic_arn
}

# SNS Topic
module "sns" {
  source = "./modules/sns"
  
  project_name = var.project_name
  environment  = var.environment
}

# SQS Queues
module "sqs" {
  source = "./modules/sqs"
  
  project_name  = var.project_name
  environment   = var.environment
  sns_topic_arn = module.sns.topic_arn
}

# Lambda Functions
module "lambda" {
  source = "./modules/lambda"
  
  project_name           = var.project_name
  environment            = var.environment
  lambda_execution_role  = module.iam.lambda_execution_role_arn
  textract_service_role  = module.iam.textract_service_role_arn
  uploads_bucket_name    = module.s3.uploads_bucket_name
  results_bucket_name    = module.s3.results_bucket_name
  sns_topic_arn          = module.sns.topic_arn
  textract_queue_arn     = module.sqs.textract_queue_arn
  start_textract_dlq_arn = module.sqs.start_textract_dlq_arn
  process_results_dlq_arn = module.sqs.process_results_dlq_arn
}