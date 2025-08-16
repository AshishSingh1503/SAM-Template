# PDF Processor Terraform Infrastructure

Production-grade Terraform infrastructure for PDF processing application using AWS Textract.

## Architecture

- **S3 Buckets**: Separate buckets for uploads and results with encryption and lifecycle policies
- **Lambda Functions**: Serverless processing with proper error handling and DLQs
- **SQS/SNS**: Reliable message processing with dead letter queues
- **IAM**: Least privilege access with specific policies

## Directory Structure

```
terraform/
├── main.tf                 # Root module
├── variables.tf           # Root variables
├── outputs.tf            # Root outputs
├── environments/         # Environment-specific configs
│   ├── dev/
│   ├── staging/
│   └── prod/
└── modules/              # Reusable modules
    ├── s3/
    ├── lambda/
    ├── sqs/
    ├── sns/
    └── iam/
```

## Usage

### Prerequisites

1. AWS CLI configured
2. Terraform >= 1.0 installed
3. S3 bucket for state storage

### Deployment

```bash
# Initialize
make init ENV=dev

# Plan changes
make plan ENV=dev

# Apply changes
make apply ENV=dev

# Format code
make fmt

# Validate configuration
make validate
```

### Environment Management

Each environment has its own:
- State file in S3
- Variable values
- Resource naming

### Security Features

- S3 bucket encryption and public access blocking
- SQS/SNS encryption with KMS
- IAM least privilege policies
- Resource-based policies
- VPC endpoints (optional)

### Cost Optimization

- S3 lifecycle policies
- Lambda reserved concurrency
- Intelligent tiering for storage
- Dead letter queues for error handling

## Customization

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Update variables for your environment
3. Modify backend configuration in environment files
4. Adjust resource configurations as needed