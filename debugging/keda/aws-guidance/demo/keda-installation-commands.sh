
#================================================================
# Connect to YOUR EKS CLUSTER thorugh kubectl as administrator.
#================================================================
export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=PHR-Sandbox.phr-infra-platform-sandbox-admin

aws sso login
# make sure your cluster is available
aws eks list-clusters

# Assume the cluster administrator role
# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/keda-addon-demo-pie-eks-admin-access --role-session-name cluster-admin1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name keda-addon-demo  --role-arn arn:aws:iam::545444110299:role/keda-addon-demo-pie-eks-admin-access
# check if keda namespace in your cluster is avalable, if not create through application_teams varaible configuration only.
kubectl get ns

#=================================================================================================
# install KEDA Set the required environment varaibles values for  Keda operator role and policy.
#=================================================================================================
export KEDA_OPERATOR_ROLENAME=keda-operator-role-tig-6024
export KEDA_NAMESPACE=keda
export KDA_SQS_GET_ATTRIBUTES_POLICY=sqsgetattributes-tig-6024

echo ${KEDA_NAMESPACE}
echo ${KEDA_OPERATOR_ROLENAME}
echo ${KDA_SQS_GET_ATTRIBUTES_POLICY}

# Create KEDA operator IAM role and attach an IAM policy to the role, which grants access to the read the sqs queue attributes, like message count etc,.
aws iam create-role --role-name ${KEDA_OPERATOR_ROLENAME} --assume-role-policy-document file://./debugging/keda/aws-guidance/demo/trust-policy-keda-operator.json
aws iam create-policy --policy-name ${KDA_SQS_GET_ATTRIBUTES_POLICY} --policy-document file://./debugging/keda/aws-guidance/demo/keda-sqs-policy.json
aws iam attach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"

#=========================================================
# install KEDA in the EKS cluster through helm chart.
#=========================================================
# Make sure helm is installed in your local system, if not install it

helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./debugging/keda/aws-guidance/demo/keda-values-v2-15.yaml
# USE keda-values-v2-15-irsa FOR aws IRSA
# helm upgrade keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./debugging/keda/aws-guidance/demo/keda-values-v2-15-irsa.yaml
helm status  ${KEDA_NAMESPACE} -n keda
# helm upgrade ${KEDA_NAMESPACE} kedacore/${KEDA_NAMESPACE} --namespace keda -f ./debugging/keda/aws-guidance/demo/keda-values.yaml
helm list -n ${KEDA_NAMESPACE}

# check if all the KEDA chart components are installed as expected.
kubectl get all -n keda

# if the Keda operator service account has the IAM role annotaton on it. this is crucial for autoscaling to work.
kubectl get serviceaccount keda-operator -n keda -o yaml

#==========================================================================================
# deploy the example nginx deployment and sqs scaler targeting sqs auto scaling
#==========================================================================================

kubectl apply -f ./debugging/keda/aws-guidance/demo/nginx-deployment.yml
kubectl apply -f ./debugging/keda/aws-guidance/demo/sqs-scaler.yml

# Push the messages into the sqs queue, and verify if its dpeloyment is autoscaling based on the messages in the sqs queue.

#=========================================================
# Cleanup after the demo
#=========================================================
# delete the deployment and sqs scaler.
kubectl delete -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/nginx-deployment.yml
kubectl delete -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/sqs-scaler.yml

# delete the Keda operator IAM role and policies.
aws iam detach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-policy  --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-role --role-name ${KEDA_OPERATOR_ROLENAME}
# uninstall the KEDA componet from EKS CLUSTER
helm uninstall keda kedacore/keda --namespace ${KEDA_NAMESPACE}