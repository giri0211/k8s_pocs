#!/bin/bash

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access

# Get a comma-separated list of namespaces from the user
read -p "Enter comma-separated list of namespaces to remove the finalizers " NAMESPACE_LIST

# echo enter namespace
# read USER_INPUT
# echo user input is $USER_INPUT

# Set IFS to comma
IFS=',' read -ra NAMESPACES <<< "$NAMESPACE_LIST"

# Loop through each namespace and execute the command
for NAMESPACE in "${NAMESPACES[@]}"; do
  echo "Processing namespace: $NAMESPACE"
  kubectl get namespace $NAMESPACE -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f -
  # kubectl delete ns $NAMESPACE  --force --grace-period=0
  # Add your command here if needed
done

# kubectl edit ns platform-showcase
# platform-showcase,project-template

# kubectl crea
# kubectl get ns

# observed that, deleting the namespace for the first time, sets the namespace in terminating status.
# second time, deleting the namespace, actually deletes the namespace.
# kubectl delete ns project-template --force --grace-period=0
# kubectl delete ns platform-showcase --force --grace-period=0

kubectl get ns
kubectl get pods --all-namespaces

kubectl get pods --namespace=platform-showcase -o json | jq -r '.items[].spec.nodeName + " " + .metadata.name' | while read node pod; do ssh "$node" "docker kill $pod"; done

kubectl delete deployment
# kubectl edit ns test-ns