data "aws_vpcs" "default" {
  count = var.vpc_id == null ? 1 : 0

  tags = {
    Name = "aws-${var.aws_region}-${local.env_short}-vpc-00"
  }
}

variable "vpc_id" {
  description = "Reference to the VPC. The default platform VPC will be used if not specified."
  type        = string
  default     = null
}

variable "aws_region" {
  description = "The AWS region. Required if `vpc_id` is not specified."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment name use in resource names. Required if `vpc_id` is not specified."
  type        = string
  default     = "phr-sandbox"
}

locals {
  env_short = var.environment != null ? trimprefix(var.environment, "phr-") : null
  
}

output "short_env" {
  value = local.env_short
}

output "aws_vpcs" {
  value = data.aws_vpcs.default[0]
}
