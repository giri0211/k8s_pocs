export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
# export AWS_PROFILE=phr-sandbox-phr-infra-platform-sandbox-admin

echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login


545444110299

 aws eks --region us-east-1 update-kubeconfig --name csa-deployments
 aws eks --region us-east-1 update-kubeconfig --name patient-access 

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



      


