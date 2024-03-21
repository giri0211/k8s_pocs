data "aws_secretsmanager_secret" "loki_secrets" {
  name = "observability-cluster-nonprod-loki-tenants"
}

data "aws_secretsmanager_secret_version" "loki_secrets" {
  secret_id = data.aws_secretsmanager_secret.loki_secrets[0].id
}

output "secrets" {
  value = data.aws_secretsmanager_secret_version.loki_secrets[0].secret_string
}
