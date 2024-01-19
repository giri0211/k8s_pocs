
 # manual state update
 # **Note** need to update the resource type in the state file before from kubernetes_namespace to kubernetes_namespace_v1
 # fro resource module.phreesia_eks.module.eks_teams[0].kubernetes_namespace.team["team-blue"]
 terraform state mv `
 'module.phreesia_eks.module.eks_teams[0].kubernetes_namespace_v1.team["team-blue"]' `
 'module.phreesia_eks.module.eks_teams[0].module.application_teams["team-blue"].kubernetes_namespace_v1.this["team-blue"]'
 
 # IAM role for application team access, permissions limited to application namespace (team-blue)
 terraform state mv `
 'module.phreesia_eks.module.eks_teams[0].aws_iam_role.team_access["team-blue"]'`
 'module.phreesia_eks.module.eks_teams[0].module.application_teams["team-blue"].aws_iam_role.this[0]'