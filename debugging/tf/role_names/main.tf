
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