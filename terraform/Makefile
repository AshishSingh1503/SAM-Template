.PHONY: help init plan apply destroy fmt validate

ENV ?= dev

help:
	@echo "Available commands:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  fmt       - Format Terraform files"
	@echo "  validate  - Validate Terraform configuration"
	@echo ""
	@echo "Usage: make <command> ENV=<environment>"
	@echo "Example: make plan ENV=dev"

init:
	cd environments/$(ENV) && terraform init

plan:
	cd environments/$(ENV) && terraform plan

apply:
	cd environments/$(ENV) && terraform apply

destroy:
	cd environments/$(ENV) && terraform destroy

fmt:
	terraform fmt -recursive .

validate:
	terraform validate