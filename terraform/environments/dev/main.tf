terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "pdf-processor/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "pdf_processor" {
  source = "../../"

  aws_region      = "us-east-1"
  project_name    = "pdf-processor"
  environment     = "dev"
  frontend_domain = "*"
}