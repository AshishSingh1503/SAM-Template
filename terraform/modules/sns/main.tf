resource "aws_sns_topic" "textract_completion" {
  name              = "${var.project_name}-textract-completion-${var.environment}"
  kms_master_key_id = "alias/aws/sns"
}