#forcefully delete the application namesapce along with the resources with in that namespace.
kubectl delete namespace <namespace-name> --force --grace-period=0

# destroy eks_teams module resources
terraform destroy -target module.phreesia_eks.module.eks_teams

# update eks template version, which includes blueprints v5 upgrade changes
# re-deploy the eks cluster. 

# re-deploy applications through argo