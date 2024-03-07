export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_PROFILE=phr-platform-dev-phr-infra-platform-sandbox-admin
echo $AWS_PROFILE 
aws sso login
