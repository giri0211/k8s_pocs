aws configure list-profiles

export AWS_PROFILE=PHR-Sandbox.phr-infra-platform-sandbox-admin
echo $AWS_PROFILE

$env:AWS_PROFILE="PHR-Sandbox.phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE

cat /mnt/c/Users/ra_Girish.Tirumalase/.aws/config

cat /mnt/c/Users/ra_Girish.Tirumalase/.kube/config

export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config



if aws-sso-util check &>/dev/null ; then \
  echo "You are not logged in. So let's log you in"
  aws-sso-util login
else
  echo "user is logged into AWS"
fi

aws eks list-clusters

16