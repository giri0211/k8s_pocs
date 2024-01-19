
# powershell
 # move state from eks_teams to eks_teams_new

 # manual state update
 # need to update the resource type in the state file before from kubernetes_namespace to kubernetes_namespace_v1
 terraform state mv `
 'module.phreesia_eks.module.eks_teams[0].kubernetes_namespace.team["team-blue"]' `
 'module.phreesia_eks.module.eks_teams[0].module.application_teams["team-blue"].kubernetes_namespace.this["team-blue"]'
 
 # IAM role for application team access, permissions limited to application namespace (team-blue)
 terraform state mv `
 'module.phreesia_eks.module.eks_teams[0].aws_iam_role.team_access["team-blue"]'`
 'module.phreesia_eks.module.eks_teams[0].module.application_teams["team-blue"].aws_iam_role.this[0]'
 
 # IAM role for Cluster adiministrator access role
 terraform state mv `
  'module.phreesia_eks.module.eks_teams[0].aws_iam_role.platform_team["admin"]'`
 'module.phreesia_eks.module.eks_teams[0].module.platform_teams["admin"].aws_iam_role.this[0]'
 
terraform state mv `
'module.phreesia_eks.module.eks_teams[0].aws_iam_policy.platform_team_eks_access[0]'`
'module.phreesia_eks.module.eks_teams[0].module.platform_teams["admin"].aws_iam_policy.admin[0]'



 #================================
# move state from eks_teams_new to eks_teams
terraform state mv `
'module.phreesia_eks.module.eks_teams_new[0].module.application_teams["team-blue"].kubernetes_namespace.this["team-blue"]'`
'module.phreesia_eks.module.eks_teams[0].kubernetes_namespace.team["team-blue"]' 
#module.phreesia_eks.module.eks_teams[0]

terraform state mv `
'module.phreesia_eks.module.eks_teams_new[0].module.application_teams["team-blue"].aws_iam_role.this[0]'`
'module.phreesia_eks.module.eks_teams[0].aws_iam_role.team_access["team-blue"]'

terraform state mv `
'module.phreesia_eks.module.eks_teams_new[0].module.platform_teams["admin"].aws_iam_policy.admin[0]'`
 'module.phreesia_eks.module.eks_teams[0].aws_iam_policy.platform_team_eks_access[0]'

