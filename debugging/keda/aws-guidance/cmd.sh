kubectl get ns


envsubst <  ./debugging/keda/aws-guidance/keda/trust-policy-keda-operator.json >  ./debugging/keda/aws-guidance/keda/trust-policy-keda-operator-sub.json 

&& mv /tmp/trust-policy-keda-operator.json keda/trust-policy-keda-operator.json


export KEDA_OPERATOR_ROLENAME=keda-operator-role-tig-6024
export KEDA_NAMESPACE=keda
export KDA_SQS_GET_ATTRIBUTES_POLICY=sqsgetattributes-tig-6024

echo ${KEDA_NAMESPACE}
echo ${KEDA_OPERATOR_ROLENAME}
echo ${KDA_SQS_GET_ATTRIBUTES_POLICY}


aws iam create-role --role-name ${KEDA_OPERATOR_ROLENAME} --assume-role-policy-document file://./debugging/keda/aws-guidance/keda/trust-policy-keda-operator.json

helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./debugging/keda/aws-guidance/keda/keda-values.yaml
helm status  ${KEDA_NAMESPACE} -n keda
helm upgrade ${KEDA_NAMESPACE} kedacore/${KEDA_NAMESPACE} --namespace keda -f ./debugging/keda/aws-guidance/keda/keda-values.yaml

helm install keda kedacore/keda

helm list -n ${KEDA_NAMESPACE}

kubectl get all -n keda

aws iam create-policy --policy-name ${KDA_SQS_GET_ATTRIBUTES_POLICY} --policy-document file://./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/setup/keda-sqs-policy.json

echo "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam attach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"

kubectl apply -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/nginx-deployment.yml
kubectl apply -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/sqs-scaler.yml

kubectl get ns

 ./debugging/keda/aws-guidance/keda/trust-policy-keda-operator.json 

#  cleanup

kubectl delete -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/nginx-deployment.yml
kubectl delete -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/sqs-scaler.yml

aws iam detach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME} --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-policy  --policy-arn "arn:aws:iam::545444110299:policy/${KDA_SQS_GET_ATTRIBUTES_POLICY}"
aws iam delete-role --role-name ${KEDA_OPERATOR_ROLENAME}

helm uninstall keda kedacore/keda --namespace ${KEDA_NAMESPACE}

echo ${KEDA_OPERATOR_ROLENAME}
aws iam detach-role-policy --role-name ${KEDA_OPERATOR_ROLENAME}


# troubleshooting oidc and service account issue.
aws eks describe-cluster --name tig-6024-keda --query "cluster.identity.oidc.issuer" --output text
kubectl get serviceaccount keda-operator -n keda -o yaml


kubectl apply -n team-blue -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/nginx-deployment.yml
kubectl apply -n team-blue -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/sqs-scaler.yml

kubectl delete -n team-blue -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/nginx-deployment.yml
kubectl delete -n team-blue -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/sqs-scaler.yml

kubectl delete -n keda -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/nginx-deployment.yml
kubectl delete -n keda -f ./debugging/keda/aws-guidance/scaledobject-samples/amazonsqs/my-examples/sqs-scaler.yml


### install through helm latest values value from v2.15 of the keda helm chart

export KEDA_OPERATOR_ROLENAME=keda-operator-role-tig-6024
export KEDA_NAMESPACE=keda
export KDA_SQS_GET_ATTRIBUTES_POLICY=sqsgetattributes-tig-6024

echo ${KEDA_NAMESPACE}
echo ${KEDA_OPERATOR_ROLENAME}
echo ${KDA_SQS_GET_ATTRIBUTES_POLICY}

helm install keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./debugging/keda/aws-guidance/keda/keda-values-v2-15.yaml
helm uninstall kedacore/keda --namespace ${KEDA_NAMESPACE}
aws eks list-clusters


### install with aws IRSA settings through helm chart version v2.15 of the keda helm chart

export KEDA_OPERATOR_ROLENAME=keda-operator-role-tig-6024
export KEDA_NAMESPACE=keda
export KDA_SQS_GET_ATTRIBUTES_POLICY=sqsgetattributes-tig-6024

echo ${KEDA_NAMESPACE}
echo ${KEDA_OPERATOR_ROLENAME}
echo ${KDA_SQS_GET_ATTRIBUTES_POLICY}

# helm install keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./debugging/keda/aws-guidance/keda/keda-values-v2-15-irsa.yaml

# helm upgrade ${KEDA_NAMESPACE} kedacore/${KEDA_NAMESPACE} --namespace keda -f ./debugging/keda/aws-guidance/keda/keda-values-v2-15-irsa.yaml
helm upgrade keda kedacore/keda --namespace ${KEDA_NAMESPACE} -f ./debugging/keda/aws-guidance/keda/keda-values-v2-15-irsa.yaml

helm status kedacore/keda

helm uninstall kedacore/keda --namespace ${KEDA_NAMESPACE}


aws eks list-clusters

kubectl get hpa -n keda