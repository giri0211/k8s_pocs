export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login


aws eks --region us-east-1 update-kubeconfig --name patient-access

# Namespace resources access IAM Role.
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/patient-access-appointment-accelerator-access --role-session-name appointment-accelerator
aws eks --region us-east-1 update-kubeconfig --name patient-access --role-arn arn:aws:iam::545444110299:role/patient-access-appointment-accelerator-access

kubectl get pods # forbidden
kubectl get pods -n platform-showcase # works

# Admin access with Cluster Administator IAM Role.
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/patient-access-admin-team-access --role-session-name patient-access-admin-team-access
aws eks --region us-east-1 update-kubeconfig --name patient-access --role-arn arn:aws:iam::545444110299:role/patient-access-admin-team-access
kubectl config current-context
aws sts get-caller-identity

kubectl get ns
kubectl get pods # works
kubectl get pods -n appointment-accelerator # works
kubectl get secrets -A

# Admin access with Cluster Administator IAM Role.
aws eks --region us-east-1 update-kubeconfig --name patient-access
kubectl get pods # works

kubectl get deploy -n  appointment-accelerator
kubectl scale deploy appointment-accelerator -n appointment-accelerator --replicas=1

kubectl describe  deploy appointment-accelerator -n appointment-accelerator
kubectl get pods -n appointment-accelerator --watch # works
kubectl get events --field-selector involvedObject.name=appointment-accelerator-67c5596d76-wwx9d --namespace appointment-accelerator

kubectl exec -it appointment-accelerator-67c5596d76-wwx9d -n appointment-accelerator -- /bin/sh


