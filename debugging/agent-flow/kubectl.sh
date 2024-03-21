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

aws eks --region us-east-1 update-kubeconfig --name TIG-4721-fargate-logs
aws eks --region us-east-1 update-kubeconfig --name tig-4721-o11y-logs

kubectl get pods -n grafana-agent
kubectl config current-context