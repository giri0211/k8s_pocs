#!/bin/bash
kubectl config current-context
latest_version=$(kubectl version -o json | jq -rj '.serverVersion|.major,".",.minor')
echo "cluster version $latest_version"
kubectl get nodes -o yaml  jsonpath='{.status.nodeInfo.kubeletVersion}'
node_version=$(kubectl get node ip-10-155-162-225.ec2.internal -o jsonpath='{.status.nodeInfo.kubeletVersion}')

# # Set your variable
# node_group_name="hi"
# # kubectl drain ip-10-155-162-225.ec2.internal --ignore-daemonsets --delete-local-data --force
# # Check if the variable has a value
# if [ -z "$node_group_name" ]; then
#     echo "Error: Variable 'node_group_name' is not set. Please set a value."
#     exit 1
# fi

nodes=$(kubectl get nodes -l eks.amazonaws.com/nodegroup=mg_5-2023120811020280720000000f  --no-headers=true -o custom-columns=":metadata.name")
for node in $nodes; do
    current_version=$(kubectl get node ip-10-155-161-252.ec2.internal -o jsonpath='{.status.nodeInfo.kubeletVersion}' | cut -d'v' -f2)
    echo "current node version is $current_version and serer version is $latest_version "
    if [[ $current_version =~ "$latest_version" ]]; then
        echo "node $node K8s version already in sync with control plane K8s version"
        echo "**********************************************************"
    else
        echo "Draining $node"
        # kubectl drain $node --ignore-daemonsets --delete-local-data --force
        echo "Drain completed on node $node"
    fi
done``



#!/bin/bash

# Specify the node name
node_name="ip-10-155-161-252.ec2.internal"

# Get kubelet version on the specified node
kubelet_version=$(kubectl get nodes $node_name -o jsonpath='{.status.nodeInfo.kubeletVersion}' | cut -d'v' -f2)

# Get Kubernetes control plane version
control_plane_version=$(kubectl version | awk '/Server Version:/ {print $3}' | cut -d'v' -f2)
echo "Kubelet version on $kubelet_version \n  control plane version $control_plane_version"

# Compare versions
if [ "$kubelet_version" == "$control_plane_version" ]; then

    echo "Kubelet version on $node_name is compatible with the control plane version."
else
    echo "Warning: Kubelet version on $node_name may not be compatible with the control plane version."
fi