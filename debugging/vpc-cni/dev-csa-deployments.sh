export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=phr-dev-aws-contractor-dev-ro
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

$env:AWS_PROFILE="phr-dev-aws-contractor-dev-ro"
$env:AWS_PROFILE
aws sso login

# Kubectl into EKS cluster with cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::768421872330:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin-4
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::768421872330:role/csa-deployments-csa-eks-admin-access \
--debug


# Connect to EKS with aws-contractor-dev-ro role 
aws eks --region us-east-1 update-kubeconfig --name csa-deployments

# get caller identity and current context on Kubernetes config
aws sts get-caller-identity
kubectl config current-context
aws configure list

# admin have access to pods in all the namespace
kubectl get pods -A

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

# Update vpc-cni add-on version on the EKS cluster v1.15.3-eksbuild.1
aws eks update-addon \
--addon-name vpc-cni \
--region us-east-1 \
--resolve-conflicts OVERWRITE \
--cluster-name csa-deployments \
--addon-version v1.15.3-eksbuild.1

# Update vpc-cni add-on version on the EKS cluster v1.15.1-eksbuild.1
aws eks update-addon \
--addon-name vpc-cni \
--region us-east-1 \
--resolve-conflicts OVERWRITE \
--cluster-name csa-deployments \
--addon-version v1.15.3-eksbuild.1

kubectl apply -f ./vpc-cni/addon-manager.yaml 
kubectl delete  -f ./debugging/vpc-cni/addon-manager.yaml 
kubectl describe clusterrole addon-manager
kubectl describe clusterrolebinding system-masters-addon-manager-cluster-role-binding

kubectl describe clusterrolebinding cluster-admin

kubectl get groups

kubectl get clusterrolebindings --all-namespaces -o custom-columns=NAME:.metadata.name,ROLE:.roleRef.name,SUBJECTS:.subjects[*].name | grep system:masters

kubectl describe clusterrole eks:addon-manager

kubectl apply -f 

aws eks list-addons --cluster-name csa-deployments
aws iam list-attached-role-policies --role-name csa-deployments-csa-eks-admin-access

aws eks list-clusters
aws eks describe-cluster --name foundations-eks
aws eks describe-addon-versions --addon-name vpc-cni

aws eks --region us-east-1 update-kubeconfig --name foundations-eks  --role-arn arn:aws:iam::768421872330:role/csa-deployments-csa-eks-admin-access
kubectl get pods -n argo-rollouts
kubectl get all -n argo-rollouts

kubectl get crd | grep rollouts
kubectl api-resources --api-group=argoproj.io
