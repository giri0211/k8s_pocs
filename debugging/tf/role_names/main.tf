
# # Find the user currently in use by AWS
# data "aws_caller_identity" "current" {}
# data "aws_partition" "current" {}

# locals {

#   platform_teams = {
#     csa-eks-admin = {
#       users = [
#         # "arn:aws:iam::768421872330:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_phr-eng-infra-platform-admin_4134382deab89b33",
#         # # "arn:aws:iam::768421872330:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_phr-dev-devops-p2-ro_7c0ac66311f90112",
#         "arn:aws:iam::768421872330:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_aws-contractor-dev-ro_4a37719d83d9c9b4"
#       ]
#     }
#   }

#   context = {
#     # aws_caller_identity
#     aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
#     aws_caller_identity_arn        = data.aws_caller_identity.current.arn
#     # aws_partition
#     aws_partition_id         = data.aws_partition.current.id
#     aws_partition_dns_suffix = data.aws_partition.current.dns_suffix
#   }

#   account_id = local.context.aws_caller_identity_account_id

#   platform_teams_config_map = length(local.platform_teams) > 0 ? distinct(flatten([
#     for platform_team_name, platform_team_data in local.platform_teams : [
#       {
#         rolearn  = "arn:${local.context.aws_partition_id}:iam::${local.account_id}:role/${var.cluster_name}-${platform_team_name}-access"
#         username = platform_team_name
#         groups = [
#           "system:masters"
#         ]
#       },
#       [
#         for platform_team_user in platform_team_data.users :
#         {
#           # replace in the sso role arn aws-reserved/sso.amazonaws.com/ with blank for required support.
#           rolearn  = replace(platform_team_user, "aws-reserved/sso.amazonaws.com/", "")
#           username = "federated-user"
#           groups = [
#             "system:masters"
#           ]
#         }
#       ]
#     ]
#   ])) : []

#    platform_team_roles = length(local.platform_teams) > 0 ? {
#   for platform_team_name, platform_team_data in local.platform_teams : 
#     "${var.cluster_name}-${platform_team_name}-access" => {
#       role_name = "${var.cluster_name}-${platform_team_name}-access"
#     }
# } : {}

# }

# # variable "platform_teams" {
# #   description = "Platform teams to create with cluster access."
# #   type        = any
# #   default     = local.platform_teams
# # }

# variable "cluster_name" {
#   description = "EKS Cluster Name"
#   type        = string

#   # EKS blueprints module appends 37 characters to the load balancer IAM role name (maximum 64 characters).
#   # Without this check, the cluster can go into a state where it's not completely stood up but can't be destroyed.
#   validation {
#     condition     = length(var.cluster_name) <= 27
#     error_message = "Cluster name must not exceed 27 characters."
#   }

#   # Regex validation on the cluster_name. Needs to follow the patter described in the error_message below.
#   validation {
#     condition     = can(regex("[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*", var.cluster_name))
#     error_message = "Cluster name must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character."
#   }

#   default = "csa-deployments"
# }


# locals {
#   arn = "arn:aws:iam::768421872330:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_aws-contractor-dev-ro_4a37719d83d9c9b4"
# }

# output "role_name" {
#   value = basename(local.arn)
# }



# output "platform_teams_config_map" {
#   value       = local.platform_teams_config_map
#   description = "test platform_teams_config_map"
# }

# # output "platform_team_role_names" {
# #   value       = data.aws_iam_role.platform_team_roles
# #   description = "test platform_teams_config_map"
# # }




# data "aws_iam_policy_document" "cluster_admin_additional_policy_doc" {
#   statement {
#     sid = "ListDescribeAll"
#     actions = [
#       "eks:DescribeAddonConfiguration",
#       "eks:DescribeAddonVersions",
#       "eks:ListClusters",
#     ]
#     resources = ["*"]
#   }

# }

# resource "aws_iam_policy" "cluster_admin_additional_policy" {
#   name        = "test-cluster-admin-additional-policy"
#   description = "testAdditional IAM Policy for AWS EKS cluster administrator"
#   policy      = data.aws_iam_policy_document.cluster_admin_additional_policy_doc.json
# }

# # # TODO: try mapping the policy to all the platform team roles
# # data "aws_iam_role" "platform_team_roles" {
# #  for_each = { for idx, arn in local.platform_teams_config_map : idx => arn }

# # #  for_each = local.platform_teams_config_map
# #  name = each.value.rolearn
# #  depends_on = [ module.eks_teams ]
# # }

# # resource "aws_iam_role_policy_attachment" "cluster_admin_additional_policy_attach" {
# #  for_each = { for idx, v in local.platform_teams_config_map : idx => v }

# #   policy_arn = aws_iam_policy.cluster_admin_additional_policy.arn
# #   role       = basename(each.value.rolearn)
# # #   depends_on = [ module.eks_teams ]
# # }


# resource "aws_iam_role_policy_attachment" "cluster_admin_additional_policy_attach" {
#  for_each = { for idx, v in local.platform_teams_config_map : idx => v }

#   policy_arn = aws_iam_policy.cluster_admin_additional_policy.arn
#   role       = basename(each.value.rolearn)
# #   depends_on = [ module.eks_teams ]
# }


# platform_team_name, platform_team_data in var.platform_team


# variable "my_data" {
#   type = list(object({
#     key1 = string
#     key2 = number
#     key3 = bool
#   }))
#   default = [
#     {
#       key1 = "value1"
#       key2 = 123
#       key3 = true
#     },
#     {
#       key1 = "value2"
#       key2 = 456
#       key3 = false
#     },
#     {
#       key1 = "value3"
#       key2 = 789
#       key3 = true
#     }
#   ]
# }

# resource "null_resource" "example" {
#   for_each = { for idx, data in var.my_data : idx => data }

#   triggers = {
#     key1 = each.value.key1
#     key2 = each.value.key2
#     key3 = each.value.key3
#   }

#   # This is just a placeholder resource for demonstration
# }

# locals {
#   platform_team_user = "arn:aws:iam::545444110299:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_aws-fte-sandbox-rw_5ff0dbcd7cea19b9"
#   replaced_by_string_match = replace(local.platform_team_user, "aws-reserved/sso.amazonaws.com/", "")
#   replaced_by_regex_match = replace(local.platform_team_user, "//.*//", "/")
# }
# output "replaced_by_string_match" {
#   value = local.replaced_by_string_match
# }

# output "replaced_by_regex_match" {
#   value = local.replaced_by_regex_match
# }

# locals {
#   # Directories start with "C:..." on Windows; All other OSs use "/" for root.
#   is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
# }

# resource "null_resource" "cli_command" {
#   provisioner "local-exec" {
#     interpreter = local.is_windows ? ["PowerShell", "-Command"] : ["/bin/bash", "-c"]
#     command     = "sleep 60"
#   }
# }

# output "is_windows" {
#   value = local.is_windows
# }

# output "pathexpand" {
#   value = pathexpand("~")
# }


provider "aws" {
  region = "us-east-1" 
    default_tags {
    tags = {
      "contact"            = "aaron-degroff"
      "costcenter"         = "cc3230"
      "domain"             = "platform-infrastructure-engineering"
      "dataclassification" = "general"
      "group"              = "terraform-modules"
      "repository"         = "terraform-aws-s3"
    }
  }
}

# data "aws_default_tags" "current" {}

# output "aws_default_tags" {
#   value = data.aws_default_tags.current.tags
# }



# data "aws_eks_cluster" "cluster" {
#   name = "keda-addon-demo"
# }

# data "aws_iam_openid_connect_provider" "oidc_provider" {
#   url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
# }



locals {
  oidc_provider_arn = "arn:aws:iam::545444110299:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/E9593BA1E15E10C4020425FDA0017E4B"
  oidc_provider_url = "https://oidc.eks.us-east-1.amazonaws.com/id/E9593BA1E15E10C4020425FDA0017E4B"
}


output "oidc_provider_domain_from_arn" {
  value = "${replace(local.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
}

output "oidc_provider_domain_from_url" {
  value = "${replace(local.oidc_provider_url, "https://", "")}:sub"
}




