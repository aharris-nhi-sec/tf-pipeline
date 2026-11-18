terraform {
  required_version = ">= 1.5.0"

  required_providers {
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

data "http" "conjur_secret" {
  url = "${var.conjur_appliance_url}/secrets/${var.conjur_account}/variable/data%2Fvault%2FOSC_APP0001%2Fcustom_rest_api%2Fusername"

  request_headers = {
    Authorization = "Token token=\"${data.http.conjur_authn.response_body}\""
  }
}

output "secret_retrieved" {
  value       = true
  description = "Confirms the secret was successfully retrieved"
}
