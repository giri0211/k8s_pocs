export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=PHR-Platform-team-dev.phr-infra-platform-sandbox-admin
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login



$env:AWS_PROFILE="PHR-Platform-team-dev.phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE
aws sso login

aws eks --region us-east-1 update-kubeconfig --name csa-deployments-3
aws eks --region us-east-1 update-kubeconfig --name csa-deployments



