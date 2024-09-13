
terraform {
  required_version = ">= 1.0.1"

  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

# akeyless needed for observability module should be non-prod for all env except for prod.

variable "akeyless_access_id" {
  type        = string
  description = "AKEYLESS access id"
  sensitive   = true
  default     = ""
}

variable "akeyless_access_key" {
  type        = string
  description = "AKEYLESS access key"
  sensitive   = true
  default     = ""
}

variable "akeyless_api_gateway_address" {
  type        = string
  description = "AKEYLESS gateway address"
  default     = "https://api-secrets-nonprod.shared-services.phreesia.services"
}

provider "akeyless" {
  api_gateway_address = var.akeyless_api_gateway_address
  api_key_login {
    access_id  = var.akeyless_access_id
    access_key = var.akeyless_access_key
  }
}