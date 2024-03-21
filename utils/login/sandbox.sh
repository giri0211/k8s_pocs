export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
# export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
export AWS_PROFILE=phr-sandbox-phr-infra-platform-sandbox-admin

echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

# $env:AWS_PROFILE="phr-sandbox-aws-contractor-sandbox-rw"
$env:AWS_PROFILE="phr-sandbox-phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE
aws sso login

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin1
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access


kubectl get pods -n grafana-agent -o wide

kubectl delete pod grafana-agent-0 -n grafana-agent
kubectl logs pod/grafana-agent-0   -n grafana-agent --since=2m