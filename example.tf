terraform {
  required_version = ">= 1.5.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment name"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

locals {
  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "null_resource" "example" {
  triggers = {
    environment = var.environment
  }

  provisioner "local-exec" {
    command = "echo 'Running in ${var.environment} environment'"
  }
}

output "environment" {
  value = var.environment
}

output "tags" {
  value = local.tags
}
