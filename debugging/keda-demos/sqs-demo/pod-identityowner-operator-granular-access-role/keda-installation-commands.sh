
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
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/keda-addon-demo-pie-eks-admin-access --role-session-name cluster-admin1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name keda-addon-demo  --role-arn arn:aws:iam::545444110299:role/keda-addon-demo-pie-eks-admin-access

# check if keda namespace in your cluster is avalable, if not create through application_teams varaible configuration only.
kubectl get ns

#=================================================================================================
# install KEDA Set the required environment varaibles values for  Keda operator role and policy.
#=================================================================================================
export KEDA_OPERATOR_ROLENAME=keda-operator-role-tig-6351
export KEDA_NAMESPACE=keda
export KDA_SQS_GET_ATTRIBUTES_POLICY=sqsgetattributes-policy-tig-6351
export KEDA_OPERATOR_GRANULAT_ACCESS_ROLE=keda-operator-sqs-granual-access-role-tig6351


echo ${KEDA_NAMESPACE}
echo ${KEDA_OPERATOR_ROLENAME}
echo ${KEDA_OPERATOR_GRANULAT_ACCESS_ROLE}
echo ${KDA_SQS_GET_ATTRIBUTES_POLICY}

# Create KEDA operator IAM role and attach an IAM policy to the role, which grants access to the read the sqs queue attributes, like message count etc,.
aws iam create-role --role-name ${KEDA_OPERATOR_ROLENAME} --assume-role-policy-document file://./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/trust-policy-keda-operator.json
# aws iam attach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"


# Create application service account IAM role
# CREATE KEDA operator granulat access IAM role to access AWS SQS queue attributes.
aws iam create-role --role-name ${KEDA_OPERATOR_GRANULAT_ACCESS_ROLE} --assume-role-policy-document file://./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/trust-policy-keda-operator-sqs-granual-access-role.json
aws iam create-policy --policy-name ${KDA_SQS_GET_ATTRIBUTES_POLICY} --policy-document file://./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/keda-sqs-policy.json
aws iam attach-role-policy --role-name ${KEDA_OPERATOR_GRANULAT_ACCESS_ROLE} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"

# create pod service account
kubectl apply -n ${KEDA_NAMESPACE}  -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/pod-identity-config.yml
#=========================================================
# install KEDA in the EKS cluster through helm chart.
#=========================================================
# Make sure helm is installed in your local system, if not install it
kubectl delete -n keda -f https://raw.githubusercontent.com/kedacore/keda/main/config/crd/bases/keda.sh_scaledobjects.yaml

helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/keda-values-v2-15-irsa.yaml
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

# Create pod service account, should have annotation for role-arn with keda granual access to AWS SQS.
kubectl apply -n keda -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/pod-serviceaccount.yml

# deployment to run with granual access service account created above
kubectl apply -n keda -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/nginx-deployment.yml 
kubectl apply -n keda -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/sqs-scaler-keda-using-granual-sqs-access-role-arn


#=========================================================
# Cleanup after the demo
#=========================================================
# delete the deployment and sqs scaler.
# deployment to run with granual access service account created above
kubectl delete -n keda -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/nginx-deployment.yml 
kubectl delete -n keda -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/sqs-scaler-keda-using-granual-sqs-access-role-arn

kubectl delete -n keda -f ./examples/fargate/keda-demos/sqs-demo/pod-identityowner-operator-granular-access-role/pod-serviceaccount.yml

# detach the AWS SQS access policy from KEDA_OPERATOR_GRANULAT_ACCESS_ROLE
aws iam detach-role-policy --role-name ${KEDA_OPERATOR_GRANULAT_ACCESS_ROLE} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-role --role-name ${KEDA_OPERATOR_GRANULAT_ACCESS_ROLE}

# delete the Keda operator IAM role and policies.
aws iam detach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-policy  --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-role --role-name ${KEDA_OPERATOR_ROLENAME}
# uninstall the KEDA componet from EKS CLUSTER
helm uninstall keda kedacore/keda --namespace ${KEDA_NAMESPACE}