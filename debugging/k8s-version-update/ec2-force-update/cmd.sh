export AWS_PROFILE=phr-platform-dev
echo $AWS_PROFILE
aws sso login

export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_PROFILE=phr-platform-dev-phr-infra-platform-sandbox-admin
echo $AWS_PROFILE 
# echo $AWS_CONFIG_FILE 
# echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login


 aws eks --region us-east-1 update-kubeconfig --name csa-deployments
kubectl describe node fargate-ip-10-155-162-88.ec2.internal
kubectl get events --sort-by='.metadata.creationTimestamp'

 aws eks --region us-east-1 update-kubeconfig --name tig-4623-ec2-drain-nodes
 kubectl get ns
 kubectl get pdb --all-namespaces

kubectl apply -f ./utils/busybox -n platform-showcase
kubectl get pods -n platform-showcase --watch
 
kubectl logs pod/network-check-66987459d4-frcr7

kubectl get nodes -l "eks.amazonaws.com/nodegroup in (mg_5-20240206153612971200000010)"  --no-headers=true -o jsonpath='{.items[*].metadata.name}'
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=ip-10-155-160-150.ec2.internal 
eksctl delete nodegroup --region us-east-1 --cluster "tig-2517-ec2-version-upd"  --name mg_5_v1_28-20231208181521234500000008





