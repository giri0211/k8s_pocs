#!/bin/bash

# Assume Admin role and with Admin Access on the EKS cluster, example command given below

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::622268126582:role/csa-deployments-admin-access-admin-access

# Get the cluster kubernetes version
latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3)
echo "cluster version $latest_version"

#test

# kubectl get node fargate-ip-10-155-161-51.ec2.internal -o jsonpath='{.status.nodeInfo.kubeletVersion}'


# grafana-agent-0 metrics pod to be restarted its a stateful set.
# check for agent kuletversion, if its different from cluster version, try to delete pod
# which in-turn creates the new pod with latest kubernetes version
# ga_metrics_pod_name="grafana-agent-0"
# ga_namespace="grafana-agent"
# ga_metrics_node=$(kubectl get pod $ga_metrics_pod_name -n $ga_namespace -o jsonpath='{.spec.nodeName}')
# ga_metrics_node_version=$(kubectl get node $ga_metrics_node -o jsonpath='{.status.nodeInfo.kubeletVersion}')
#  if [[ $ga_metrics_node_version =~ "$latest_version" ]]; then
#     echo "Pod $ga_metrics_pod_name in namespace $ga_namespace is already on the latest node"
#     echo "**********************************************************"
# else
#     echo "Pod $ga_namespace in namespace $ga_namespace is on an old node, need to recreate"
#     kubectl delete pod  grafana-agent-0 -n grafana-agent
    
#     # Define a timeout (in seconds) for the wait loop
#     timeout_seconds=300
#     end_time=$((SECONDS + timeout_seconds))

#     # Loop until the new pod is ready or the timeout is reached
#     while [ $SECONDS -lt $end_time ]; do
#         pod_status=$(kubectl get pod $ga_metrics_pod_name -n $ga_namespace -o jsonpath='{.status.phase}')

#         if [ "$pod_status" == "Running" ]; then
#             echo "Pod $ga_metrics_pod_name is now in Running state."
#             break
#         elif [ "$pod_status" == "Pending" ]; then
#             echo "Pod $ga_metrics_pod_name is still in Pending state. Waiting..."
#         else
#             echo "Pod $ga_metrics_pod_name is in an unexpected state: $pod_status"
#             break
#         fi

#         sleep 10
#     done

#     if [ $SECONDS -ge $end_time ]; then
#         echo "Timeout reached. The new pod may not be in the desired state within $timeout_seconds seconds."
#     fi

#     echo "**********************************************************"
# fi



# Get the cluster kubernetes version
latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3 | awk -F'.' '{print $1 "." $2}')

# latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3 | awk -F'.' '{print $1 "." $2}')
# echo $latest_version
# node_version=$(kubectl get node fargate-ip-10-155-162-141.ec2.internal  -o jsonpath='{.status.nodeInfo.kubeletVersion}' | awk -F'.' '{print $1 "." $2}')
# echo $node_version

# if [[ $node_version != $latest_version ]]; then
#     echo "version different"
#     echo "**********************************************************"
# else
#      echo "version same "
# fi



# kubectl version | grep "Server Version" | cut -d " " -f 3 | awk -F'.' '{print $1 "." $2}'
# kubectl get node fargate-ip-10-155-162-141.ec2.internal  -o jsonpath='{.status.nodeInfo.kubeletVersion}' | awk -F'.' '{print $1 "." $2}'


latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3 | awk -F'.' '{print $1 "." $2}')
echo "control plane kubernetes $latest_version"

declare -A deployment_list  # Associative array to store the list of deployments

# Loop through all namespaces and restart the pods through deployment rollout
# This script restarts the pods with zero down time, as it rollouts the deployments, with rolling updates.
for namespace in $(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'); do
    echo "Checking namespace: $namespace"
    
    # Loop through all pods in the current namespace
    for pod in $(kubectl get pod -n $namespace --no-headers=true --field-selector=status.phase!=Succeeded -o custom-columns=":metadata.name"); do

        faragte_node=$(kubectl get pod $pod -n $namespace -o jsonpath='{.spec.nodeName}')
        deployment_found=false

        for dep in $(kubectl get deployment -n $namespace --no-headers=true -o custom-columns=":metadata.name"); do
            if [[ $pod =~ "$dep" ]]; then
                deployment=$dep
                deployment_found=true
                break
            fi
        done

        if $deployment_found; then
            current_version=$(kubectl get node $faragte_node -o jsonpath='{.status.nodeInfo.kubeletVersion}' | awk -F'.' '{print $1 "." $2}')

            if [[ $current_version == "$latest_version" ]]; then
                echo "Pod $pod in namespace $namespace is already on the latest node"
                echo "**********************************************************"
            elif [[ -n "${deployment_list["$namespace/$deployment"]}" ]]; then
                # Deployment is already in the list, skip rollout.
                echo "Deployment $deployment in namespace $namespace is already restarted, skipping"
                echo "**********************************************************"
            else
                echo "Pod $pod in namespace $namespace is on an old node, need deployment restart rollout"
                # kubectl rollout restart deployment $deployment -n $namespace
                # kubectl rollout status deployment $deployment -n $namespace
                deployment_list["$namespace/$deployment"]="restarted"  # Add deployment to the list
                echo "**********************************************************"
            fi
        else
            echo "Deployment not found for pod $pod in namespace $namespace, skipping"
        fi
    done
done

# ensure the kubelet version is updated with latest kubernetes version, for all the nodes.
kubectl get nodes

# ensure the kubelet version is updated with latest kubernetes version, for all the nodes.
# kubectl get nodes
# Check pods running on a given node
# kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=fargate-ip-10-155-162-46.ec2.internal 

# Below commands are only for reference, and need to set the cluster_name, region, node_group_name, node_name as per cluster being updated.
# Get node group names on the cluster.
aws eks list-nodegroups --cluster-name $cluster_name --region $region
# Get nodes from the node group created for version 1.27
kubectl get nodes -l "eks.amazonaws.com/nodegroup in ($node_group_name)"  --no-headers=true -o jsonpath='{.items[*].metadata.name}'
# Check pods running on a given node
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=fargate-ip-10-155-162-46.ec2.internal 
