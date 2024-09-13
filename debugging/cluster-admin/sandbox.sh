export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
#export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
export AWS_PROFILE=phr-sandbox-phr-infra-platform-sandbox-admin
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

# $env:AWS_PROFILE="phr-sandbox-phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE="phr-sandbox-aws-contractor-sandbox-rw"
$env:AWS_PROFILE
aws sso login


$env:AWS_PROFILE="phr-sandbox-phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE
aws sso login


phr-sandbox-phr-infra-platform-sandbox-admin

aws iam list-roles --query 'Roles[?contains(RoleName, `csa-deployments`)]'

aws iam list-roles --query 'Roles[?RoleName==`csa-deployments-csa-eks-admin-access`].Arn'
aws iam list-roles --query 'Roles[?RoleName==`csa-deployments-project-template-access`].Arn'

# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access

aws eks --region us-east-1 update-kubeconfig --name integrations-core
# namespace access role csa-deployments-project-template-access

# Assume the namespace access role csa-deployments-project-template-access
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-project-template-access --role-session-name ns-access1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-project-template-access

aws sts assume-role --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-csa-eks-admin-access --role-session-name cluster-admin1
aws eks --region us-east-1 update-kubeconfig --name pie-deployments-green --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-csa-eks-admin-access

# Assume the namespace access role csa-deployments-project-template-access
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-platform-showcase-access --role-session-name ns-access1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name pie-deployments-green --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-platform-showcase-access

# get caller identity and current context on Kubernetes config
aws sts get-caller-identity
kubectl config current-context

# admin have access to pods in default namespace
kubectl get pods -A
kubectl get pods -n project-template
kubectl get pods -n platform-showcase
# get the current VPC-CNI add-on version on the EKS cluster
aws eks describe-addon --cluster-name csa-deployments --addon-name vpc-cni --query addon.addonVersion --output text

# describe vpc-cni add-on version compatable with cluster k8s version
aws eks describe-addon-versions \
--addon-name vpc-cni \
--region us-east-1 \
--query "addons[].addonVersions[].[addonVersion, compatibilities[].defaultVersion]" \
--output text \
--kubernetes-version 1.28

# v1.15.1-eksbuild.1
# v1.15.3-eksbuild.1

# Update vpc-cni add-on version on the EKS cluster.
aws eks update-addon \
--addon-name vpc-cni \
--region us-east-1 \
--resolve-conflicts OVERWRITE \
--cluster-name csa-deployments \
--addon-version v1.15.3-eksbuild.1
