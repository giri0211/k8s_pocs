export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
# export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
# export AWS_PROFILE=phr-sandbox-phr-infra-platform-sandbox-admin
export AWS_PROFILE=PHR-Sandbox.phr-infra-platform-sandbox-admin


echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

$env:AWS_CONFIG_FILE="C:\Users\ra_Girish.Tirumalase\.aws\config"

export AWS_PROFILE=PHR-Platform-team-dev.phr-infra-platform-sandbox-admin
export AWS_PROFILE=PHR-Dev.aws-contractor-dev-ro

$env:AWS_PROFILE="PHR-Sandbox.phr-infra-platform-sandbox-admin" 
aws eks list-clusters

aws sts assume-role --role-arn arn:aws:iam::545444110299:role/tig-5844-fs-sg-admin-access --role-session-name cluster-admin
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name tig-5844-fs-sg  --role-arn arn:aws:iam::545444110299:role/tig-5844-fs-sg-admin-access


aws ec2 describe-network-interfaces --filters "Name=group-id,Values=sg-07903b8f4b6da84d0"

kubectl patch pvc agent-wal-grafana-agent-0 -n grafana-agent --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'

kubectl get ns 

kubectl get namespace grafana-agent -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/grafana-agent/finalize" -f -
echo "Deleting the namespace: grafana-agent"
kubectl delete ns grafana-agent --wait=false --force --grace-period=0

  kubectl delete pod grafana-agent-0 -n grafana-agent --wait=false --force --grace-period=0

kubectl delete pvc agent-wal-grafana-agent-0 -n grafana-agent
kubectl delete pv grafana-agent -n grafana-agent
kubectl delete sc grafana-agent -n grafana-agent

kubectl get all -n grafana-agent
kubectl get secret -n grafana-agent
# List all resources in the namespace:
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl -n external-dns get --ignore-not-found

kubectl get all -n external-dns
kubectl config current-context
kubectl get pods -n grafana-agent


kubectl get namespace external-dns -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/external-dns/finalize" -f -
echo "Deleting the namespace: grafana-agent"
kubectl delete ns external-dns --wait=false --force --grace-period=0