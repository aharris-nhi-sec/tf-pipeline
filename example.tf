terraform {
  required_version = ">= 1.5.0"

  required_providers {
    conjur = {
      source  = "cyberark/conjur"
      version = "~> 0.6"
    }
  }
}

variable "conjur_jwt_token" {
  type        = string
  sensitive   = true
  description = "GitHub Actions OIDC JWT token for Conjur authentication"
}

provider "conjur" {
  appliance_url = "https://sme-andrew.secretsmgr.cyberark.cloud/api"
  account       = "conjur"

  authn_jwt {
    service_id = "github"
    token      = var.conjur_jwt_token
  }
}

data "conjur_secret" "api_username" {
  name = "data/vault/OSC_APP0001/custom_rest_api/username"
}

output "secret_retrieved" {
  value       = true
  description = "Confirms the secret was successfully retrieved"
}
