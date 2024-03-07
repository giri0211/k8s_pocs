provider "kubernetes" {
  alias                  = "argocd-kubernetes"
  host                   = var.argocd_cluster_endpoint
  cluster_ca_certificate = base64decode(var.argocd_cluster_certificate_data)
  token                  = data.aws_secretsmanager_secret_version.argocd_kubernetes_token_version.secret_string
}
