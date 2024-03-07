data "aws_secretsmanager_secret" "argocd_kubernetes_token" {
  name = var.argocd_cluster_secret_name
}

data "aws_secretsmanager_secret_version" "argocd_kubernetes_token_version" {
  secret_id = data.aws_secretsmanager_secret.argocd_kubernetes_token.id
  version_id = var.argocd_cluster_secret_version_id
  version_stage = var.argocd_cluster_secret_version_stage
}

#-------------------------------
# Argo CD
#-------------------------------
variable "argocd_registration" {
  description = "If enabled, cluster is registered in Argo CD"
  type        = bool
  default     = true
}

variable "argocd_cluster_endpoint" {
  type        = string
  description = "The API endpoint of the Kubernetes cluster where Argo CD is running."
  default     = "https://133E1C4F790BC47C1836B63FD9CC4DDE.gr7.us-east-1.eks.amazonaws.com"
}

variable "argocd_cluster_certificate_data" {
  type        = string
  description = "The base64-encoded certificate data of the Kubernetes cluster where Argo CD is running."
  default     = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJVUlUU3BveUJLbE13RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpFeE1Ea3hOVFU0TlRkYUZ3MHpNekV4TURZeE5qQXpOVGRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUNwRU9XNjlpN1I4cllzdFU3RFZzd1gwSEM0azk3WTZ5ZkV0OEM1dCtwaktIUG1WK2tEQzBSczFyRVEKbHMycEluMkoxV3ZLdU92ejZYa1lGWHRBWGhSQUxTWHpxT0pGOElSTnNIeXV4akpISHZpTEZDN2licG5rZUtsYgpxZDhmck01SERLYm41OUI0S3FsQWRvRHgrNU9rblFMSFdMTTB2cUdDWGY0MUd2L0FKY09HbXg5VFRqWk5wT2VVCkZQUUF3bDNaSXcyWklLMEkwTEQ3WnZiVDN1SGpnMWRRQ1NFQWRaYXZOaEpxZDhUQmE3SE5xU1NQV1ZlUEltdnoKYmNiL01vZ0pOVXhRcExDYlJ5N096Sy9ZYU0yTjVMZ09jeW5DaTJrTkkrNE1rS1dDZkdHRGU3OGtPcWM5b21LNwpBUVVjcGIyd3BVWmZNaS9tSmQ2d00xT2xnZkFSQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSaUc0RCtCNUYvNVk3Y0N5aFpub0ZCYi9Sek9qQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ1hHMTFFcjNPVgpQV1lkd05VdURDZno4Y3ZGcUJMekt2Q21JanRsM3FCRzhHSHpTakNiK2xXV3JPdlZoQnZSbVFYc3JPL3hWc0xCCi9UdnRKM1BuUzBWV3QxWlpuT2I0eFdVcjlvcFZkNklkM2NWR2Yyb3Q0TlprWEZGa0hFWUhIU3Q5MW9pVTVaMzAKUDZIMGtFN0o2QmtMSlZuRTJXeENBbXZoR3Byb2dTVkFQMmxEY0ZKWjRCQTFXdGg5RHpHNThMU0hjdmY3blZ4LwpSSTJ1cjJEaEZpVEY1TVdsNU4vVVFnR1VPZmxLOWJmcUVlWnh4cDRZblhMaE9Xb2JRblJla0haRW1DNEVleS9HCkhvOW43SnFkLzdXMkQrYWd6cEZNUmdJcEY4T1N3Q3FZckcrS1REUFh2R0FFUmxmVGM4Qk85U0hpUWl4b2V1NFIKSitvVjlQZmVseGNRCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
}

variable "argocd_cluster_secret_name" {
  type        = string
  description = "The SecretsManager secret holding the authentication/authorization token of the Kubernetes cluster where Argo CD is running."
  default     = "argocd_cluster_token"
}

variable "argocd_cluster_secret_version_id" {
  type        = string
  description = "Version of the SecretsManager secret holding the authentication/authorization token of the Kubernetes cluster where Argo CD is running."
  default     = null
#    default = "607dcb25-a3d7-4783-9604-5d17bf380946"
}

variable "argocd_cluster_secret_version_stage" {
  type        = string
  description = "Staging label attached to the version of the SecretsManager secret holding the authentication/authorization token of the Kubernetes cluster where Argo CD is running."
  default     = "AWSCURRENT"
#   default     = "AWSPREVIOUS"
}

output "argocd_kubernetes_token_secret_string" {
 value = data.aws_secretsmanager_secret_version.argocd_kubernetes_token_version.secret_string
 sensitive = true
}
