#!/bin/bash

# Assume Admin role and with Admin Access on the EKS cluster, example command given below

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access

# Get the cluster kubernetes version
latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3)
echo "cluster version $latest_version"

# grafana-agent-0 metrics pod to be restarted its a stateful set.
# check for agent kuletversion, if its different from cluster version, try to delete pod
# which in-turn creates the new pod with latest kubernetes version
ga_metrics_pod_name="grafana-agent-0"
ga_namespace="grafana-agent"
ga_metrics_node=$(kubectl get pod $ga_metrics_pod_name -n $ga_namespace -o jsonpath='{.spec.nodeName}')
ga_metrics_node_version=$(kubectl get node $ga_metrics_node -o jsonpath='{.status.nodeInfo.kubeletVersion}')
 if [[ $ga_metrics_node_version =~ "$latest_version" ]]; then
    echo "Pod $ga_metrics_pod_name in namespace $ga_namespace is already on the latest node"
    echo "**********************************************************"
else
    echo "Pod $ga_namespace in namespace $ga_namespace is on an old node, need to recreate"
    kubectl delete pod  grafana-agent-0 -n grafana-agent
    
    # Define a timeout (in seconds) for the wait loop
    timeout_seconds=300
    end_time=$((SECONDS + timeout_seconds))

    # Loop until the new pod is ready or the timeout is reached
    while [ $SECONDS -lt $end_time ]; do
        pod_status=$(kubectl get pod $ga_metrics_pod_name -n $ga_namespace -o jsonpath='{.status.phase}')

        if [ "$pod_status" == "Running" ]; then
            echo "Pod $ga_metrics_pod_name is now in Running state."
            break
        elif [ "$pod_status" == "Pending" ]; then
            echo "Pod $ga_metrics_pod_name is still in Pending state. Waiting..."
        else
            echo "Pod $ga_metrics_pod_name is in an unexpected state: $pod_status"
            break
        fi

        sleep 10
    done

    if [ $SECONDS -ge $end_time ]; then
        echo "Timeout reached. The new pod may not be in the desired state within $timeout_seconds seconds."
    fi

    echo "**********************************************************"
fi

# Loop through all namespaces and restart the pods through deployment rollout
# This script restarts the pods with zero down time, as it rollouts the deployments, with rolling updates.
for namespace in $(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'); do
    echo "Checking namespace: $namespace"
    
    # Loop through all pods in the current namespace
    for pod in $(kubectl get pod -n $namespace --no-headers=true --field-selector=status.phase!=Succeeded -o custom-columns=":metadata.name"); do

        faragte_node=$(kubectl get pod $pod -n $namespace -o jsonpath='{.spec.nodeName}')

        for dep in $(kubectl get deployment -n $namespace --no-headers=true -o custom-columns=":metadata.name"); do
            if [[ $pod =~ "$dep" ]]; then
                deployment=$dep
            fi
        done

        current_version=$(kubectl get node $faragte_node -o jsonpath='{.status.nodeInfo.kubeletVersion}')

        if [[ $current_version =~ "$latest_version" ]]; then
            echo "Pod $pod in namespace $namespace is already on the latest node"
            echo "**********************************************************"
        else
            echo "Pod $pod in namespace $namespace is on an old node, need deployment restart rollout"
            kubectl rollout restart deployment -n $namespace
            kubectl rollout status deployment -n $namespace
            echo "**********************************************************"
        fi
    done
done

# ensure the kubelet version is updated with latest kubernetes version, for all the nodes.
kubectl get nodes