export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
# export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
# export AWS_PROFILE=phr-sandbox-phr-infra-platform-sandbox-admin
export AWS_PROFILE=PHR-Sandbox.phr-infra-platform-sandbox-admin


 aws eks list-clusters

echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

aws eks list-clusters

$env:AWS_CONFIG_FILE="C:\Users\ra_Girish.Tirumalase\.aws\config"

export AWS_PROFILE=PHR-Platform-team-dev.phr-infra-platform-sandbox-admin
export AWS_PROFILE=PHR-Dev.aws-contractor-dev-ro

echo $AWS_PROFILE
#sandbox
$env:AWS_PROFILE="PHR-Sandbox.phr-infra-platform-sandbox-admin" 
#platform-dev
$env:AWS_PROFILE="PHR-Platform-team-dev.phr-infra-platform-sandbox-admin"
#dev
$env:AWS_PROFILE="PHR-Dev.aws-contractor-dev-ro" 

# $env:AWS_PROFILE="phr-sandbox-aws-contractor-sandbox-rw"
# $env:AWS_PROFILE="phr-sandbox-phr-infra-platform-sandbox-admin"
# $env:AWS_PROFILE="phr-sandbox-infra-platform-engineer"

$env:AWS_PROFILE
aws sso login
aws eks --region us-east-1 update-kubeconfig --name keda-poc

aws eks --region us-east-1 update-kubeconfig --name pie-deployments-vpa
aws eks --region us-east-1 update-kubeconfig --name ex2-tig-5658-auth-config
aws eks --region us-east-1 update-kubeconfig --name pie-aws-auth-fargate

aws eks --region us-east-1 update-kubeconfig --name ec2-o11y-test

# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/ex2-tig-5658-auth-config-admin-access --role-session-name cluster-admin1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name ex2-tig-5658-auth-config  --role-arn arn:aws:iam::545444110299:role/ex2-tig-5658-auth-config-admin-access


# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/pie-keda-csa-eks-admin-access --role-session-name cluster-admin1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name pie-keda  --role-arn arn:aws:iam::545444110299:role/pie-keda-csa-eks-admin-access

# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/tig-6024-keda-csa-eks-admin-access --role-session-name cluster-admin1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name tig-6024-keda  --role-arn arn:aws:iam::545444110299:role/tig-6024-keda-csa-eks-admin-access





# get caller identity and current context on Kubernetes config
aws sts get-caller-identity
kubectl config current-context
kubectl whoami

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin1
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access

aws sts assume-role --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-platform-showcase-access --role-session-name ns-access-1
aws eks --region us-east-1 update-kubeconfig --name pie-deployments-green --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-platform-showcase-access

kubectl get pods -n grafana-agent -o wide

kubectl delete pod grafana-agent-0 -n grafana-agent
kubectl logs pod/grafana-agent-0   -n grafana-agent --since=2m

kubectl get sgp

