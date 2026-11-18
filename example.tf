terraform {
  required_version = ">= 1.5.0"

  required_providers {
    conjur = {
      source  = "cyberark/conjur"
      version = "~> 0.6"
    }
  }
}

provider "conjur" {
  appliance_url = "https://sme-andrew.secretsmgr.cyberark.cloud/api"
  account       = "conjur"
}

data "conjur_secret" "api_username" {
  name = "data/vault/OSC_APP0001/custom_rest_api/username"
}

output "secret_retrieved" {
  value       = true
  description = "Confirms the secret was successfully retrieved"
}
