#!/bin/bash

# platfrom-dev
# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::622268126582:role/tig-4658-csa-eks-1-26-csa-eks-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name tig-4658-csa-eks-1-26  --role-arn arn:aws:iam::622268126582:role/tig-4658-csa-eks-1-26-csa-eks-admin-access


# sandbox

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::545444110299:policy/csa-deployments-csa-eks-admin-administrator-access --role-session-name cluster-admin-1
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-administrator-access



# Get a comma-separated list of namespaces from the user
read -p "Enter comma-separated list of namespaces to delete the resources " NAMESPACE_LIST

# echo enter namespace
# read USER_INPUT
# echo user input is $USER_INPUT
# platform-showcase,project-template
# Set IFS to comma
IFS=',' read -ra NAMESPACES <<< "$NAMESPACE_LIST"

# Loop through each namespace and execute the command
for NAMESPACE in "${NAMESPACES[@]}"; do
  echo "Processing namespace: $NAMESPACE"
  echo "Deleting the resources in the namespace: $NAMESPACE"
  # Delete all the resources in the namespace
  kubectl delete --all --namespace="$NAMESPACE" pods,deployments,services,replicasets,statefulsets,daemonsets,configmaps,secrets,ingresses,roles,rolebindings,serviceaccounts --wait=false --force --grace-period=0
  # Update the finalizer null on the namespace
  kubectl get namespace $NAMESPACE -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f -
  echo "Deleting the namespace: $NAMESPACE"
  # Delete the namespace
  kubectl delete ns $NAMESPACE --wait=false --force --grace-period=0
done

# if any resources still exists in the namespace or namespace it self is in terminating state
# try running the above script again till we see No resources found for deletion command.

# kubectl get ns
# kubectl get pods --all-namespaces
# kubectl get events --field-selector involvedObject.name=ps-contentmanagement-df8fd7f75-cw6cn --namespace platform-showcase

# kubectl get sgp 
