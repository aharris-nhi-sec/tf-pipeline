terraform {
  required_version = ">= 1.5.0"

  required_providers {
    conjur = {
      source  = "cyberark/conjur"
      version = "~> 0.6"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

variable "conjur_appliance_url" {
  type    = string
  default = "https://sme-andrew.secretsmgr.cyberark.cloud/api"
}

variable "conjur_account" {
  type    = string
  default = "conjur"
}

variable "conjur_jwt_service_id" {
  type    = string
  default = "github"
}

variable "github_jwt" {
  type      = string
  sensitive = true
}

data "http" "conjur_authn" {
  url    = "${var.conjur_appliance_url}/authn-jwt/${var.conjur_jwt_service_id}/${var.conjur_account}/authenticate"
  method = "POST"

  request_headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }

  request_body = "jwt=${var.github_jwt}"
}

provider "conjur" {
  appliance_url = var.conjur_appliance_url
  account       = var.conjur_account
  authn_token   = data.http.conjur_authn.response_body
}

data "conjur_secret" "api_username" {
  name = "data/vault/OSC_APP0001/custom_rest_api/username"
}

output "secret_retrieved" {
  value       = true
  description = "Confirms the secret was successfully retrieved"
}
