export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=phr-platform-dev-phr-infra-platform-sandbox-admin
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

$env:AWS_PROFILE="phr-platform-dev-phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE
aws sso login

aws configure sso
aws eks --region us-east-1 update-kubeconfig --name csa-deployments

aws ec2 describe-subnets --subnet-ids subnet-0efca800c3cbd1a50 --query "Subnets[*].AvailableIpAddressCount" 
aws ec2 describe-subnets --subnet-ids subnet-02a67745eedcfd6d2 --query "Subnets[*].AvailableIpAddressCount" 

subnet-01c766c1a51cd9a16 

 kubectl get ns


aws sts assume-role --role-arn arn:aws:iam::768421872330:role/authentication-eks-admin-accesss --role-session-name admin-access
aws eks --region us-east-1 update-kubeconfig --name authentication --role-arn arn:aws:iam::768421872330:role/authentication-eks-admin-access

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access

kubectl get ns
kubectl get pods -n appointment-accelerator --watch
kubectl logs pod/appointment-accelerator-667c5b4d6c-4b752  -n appointment-accelerator -w

kubectl logs -l app=appointment-accelerator -n appointment-accelerator -f

kubectl get deploy -n appointment-accelerator
kubectl describe deploy appointment-accelerator 
kubectl get events --field-selector involvedObject.kind=Deployment,involvedObject.name=appointment-accelerator `
-n appointment-accelerator --watch




kubectl edit deploy appointment-accelerator -n appointment-accelerator

kubectl scale deploy appointment-accelerator -n appointment-accelerator --replicas=1

kubectl exec -it pod/appointment-accelerator-667c5b4d6c-4b752 -n appointment-accelerator -- /bin/sh

bundle
      exec
      puma
      -C
      config/puma.rb
      

      list-addons --cluster-name tig-4658-csa-eks-1-26

