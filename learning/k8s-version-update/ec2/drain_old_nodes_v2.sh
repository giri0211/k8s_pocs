cluster_name="tig-2517-ec2-version-upd"
region="us-east-1"
# node group to be deleted
node_group_names="mg_5_v1_27-20231208173847401500000008"

IFS=',' read -ra node_groups <<< "$node_group_names"

for node_group in "${node_groups[@]}"; do
    echo "Processing nodes in node group: $node_group"
    # get every node in the nodegroup to be deleted and drain the workloads to newly created and upgraded nodegroup.
    nodes=$(kubectl get nodes -l "eks.amazonaws.com/nodegroup in ($node_group)"  --no-headers=true -o jsonpath='{.items[*].metadata.name}')
    for node in $nodes; do
        echo "Draining $node"
        kubectl drain $node --ignore-daemonsets --delete-local-data --force
        echo "Drain completed on node $node"
        kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=$node
    done
    # Delete nodegroup
    eksctl delete nodegroup --region $region --cluster $cluster_name --name $node_group
done


# cluster_name="tig-2517-ec2-version-upd" 
# region="us-east-1"
# node_group="mg_5-2023120816433917550000000f"
eksctl delete nodegroup --region us-east-1 --cluster "tig-2517-ec2-version-upd"  --name mg_5-2023120816433917550000000f

sudo apt-get update && sudo apt-get install -y jq
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | sudo tar xz -C /usr/local/bin



# kubectl delete pod/aws-node-cppnn -n kube-system --grace-period=0 --force
 
# kubectl uncordon ip-10-155-162-225.ec2.internal 

# kubectl logs pod/aws-node-z2rd9 -n kube-system

kubectl get nodes -l "eks.amazonaws.com/nodegroup in (mg_5_v1_27-20231208173847401500000008)"  --no-headers=true -o jsonpath='{.items[*].metadata.name}'
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=ip-10-155-161-10.ec2.internal
eksctl delete nodegroup --region us-east-1 --cluster "tig-2517-ec2-version-upd"  --name mg_5_v1_27-20231208173847401500000008

kubectl get nodes -l "eks.amazonaws.com/nodegroup in (mg_5_v1_28-20231208181521234500000008)"  --no-headers=true -o jsonpath='{.items[*].metadata.name}'
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=ip-10-155-162-203.ec2.internal
eksctl delete nodegroup --region us-east-1 --cluster "tig-2517-ec2-version-upd"  --name mg_5_v1_28-20231208181521234500000008

