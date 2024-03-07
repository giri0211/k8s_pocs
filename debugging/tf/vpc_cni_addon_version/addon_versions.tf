# # data "external" "eks_addon_versions" {
# #   program = ["aws", "eks", "describe-addon-versions", "--addon-name", "vpc-cni", "--kubernetes-version", "1.26", "--query", "addons[].addonVersions[].[addonVersion, compatibilities[].defaultVersion]", "--output", "json"]
# # }

# data "external" "eks_addon_versions" {
#   program = ["aws", "eks", "describe-addon-versions", "--addon-name", "vpc-cni", "--kubernetes-version", "1.26", "--query", "addons[].addonVersions[].{addonVersion: addonVersion, defaultVersion: compatibilities[].defaultVersion}", "--output", "json"]
# }
# output "vpc_cni_addon_versions" {
#   value = jsondecode(data.external.eks_addon_versions.result)
#   description = "vpc_cni_addon_versions"
# }



resource "null_resource" "eks_addon_versions" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks describe-addon-versions \
        --addon-name vpc-cni \
        --kubernetes-version 1.26 \
        --query "addons[].addonVersions[].[addonVersion, compatibilities[].defaultVersion]" \
        --output json > addon_versions.json
    EOT
  }
}

data "local_file" "addon_versions" {
  depends_on = [null_resource.eks_addon_versions]
  filename   = "./addon_versions.json"
}

output "addon_versions" {
  value = jsondecode(data.local_file.addon_versions.content)
}