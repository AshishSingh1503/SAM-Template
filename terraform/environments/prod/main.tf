terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "pdf-processor/prod/terraform.tfstate"
    region = "us-east-1"
  }
}

module "pdf_processor" {
  source = "../../"

  aws_region      = "us-east-1"
  project_name    = "pdf-processor"
  environment     = "prod"
  frontend_domain = "https://your-production-domain.com"
}