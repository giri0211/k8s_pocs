export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=phr-dev
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login

kubectl config current-context
aws sts get-caller-identity
kubectl get pods -A

export AWS_PROFILE=phr-dev
echo $AWS_PROFILE 
aws sso login

# Namespace resources access IAM Role.
aws eks --region us-east-1 update-kubeconfig --name tig-4829-ec2-nodes
aws sts assume-role --role-arn arn:aws:iam::768421872330:role/tig-4829-ec2-nodes-csa-eks-admin-access --role-session-name platform-showcase-access
aws eks --region us-east-1 update-kubeconfig --name tig-4829-ec2-nodes --role-arn arn:aws:iam::768421872330:role/tig-4829-ec2-nodes-platform-showcase-access

kubectl get pods # forbidden
kubectl get pods -n platform-showcase # works

# Admin access with Cluster Administator IAM Role.
aws sts assume-role --role-arn arn:aws:iam::768421872330:role/tig-4829-ec2-nodes-csa-eks-admin-access --role-session-name admin-access
aws eks --region us-east-1 update-kubeconfig --name tig-4829-ec2-nodes --role-arn arn:aws:iam::768421872330:role/tig-4829-ec2-nodes-csa-eks-admin-access
kubectl config current-context
aws sts get-caller-identity

kubectl get pods # works
kubectl get pods -n platform-showcase # works

# Admin access with Cluster Administator IAM Role.
aws eks --region us-east-1 update-kubeconfig --name tig-4829-ec2-nodes
kubectl get pods # works
kubectl get pods -n platform-showcase # works

