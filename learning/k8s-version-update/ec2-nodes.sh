kubectl version
kubectl get nodes -o wide

kubectl version -o json | jq -rj '.serverVersion|.major,".",.minor'
kubectl version -o json | jq -r '.serverVersion.major, ".", .serverVersion.minor'

aws eks --region us-east-1 update-kubeconfig --name tig-2517-ec2-version-upd  --role-arn arn:aws:iam::622268126582:role/tig-2517-ec2-version-upd-admin-access

kubectl version -o json | jq -rj '.serverVersion|.major,".",.minor'

kubectl version --short
kubectl version  | grep "Server Version|.major,".",.minor"

kubectl apply -f ./utils/logger_service/logger-service.yml
kubectl get pods,svc -o wide

kubectl get pods -o wide -n grafana-agent
kubectl get nodes -o wide
kubectl logs pod/grafana-agent-0 -n grafana-agent 
kubectl get pv,pvc -n grafana-agent -o wide

kubectl get pv -n grafana-agent -o wide

kubectl cordon ip-10-155-161-252.ec2.internal
kubectl uncordon ip-10-155-161-252.ec2.internal



kubectl port-forward service/logger-server 8083:80

kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=ip-10-155-162-225.ec2.internal --show-labels
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=ip-10-155-161-252.ec2.internal

node_names=$(kubectl get nodes -l 'eks.amazonaws.com/nodegroup in (mg_5-2023120811020280720000000f)')
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName in ($node_names)

# Get node names based on label selector and convert to comma-separated list
node_names=$(kubectl get nodes -l 'eks.amazonaws.com/nodegroup in (mg_5-2023120811020280720000000f)' -o jsonpath='{.items[*].metadata.name}' | tr ' ' ',')

# Use the node names to get pods across all namespaces
kubectl get pods --all-namespaces --field-selector spec.nodeName in ($node_names)


$(kubectl get nodes -l 'eks.amazonaws.com/nodegroup in (mg_5-2023120811020280720000000f)')

kubectl get pods --all-namespaces -o wide -l 'eks.amazonaws.com/nodegroup in (mg_5-2023120811020280720000000f)'



kubectl drain ip-10-155-162-225.ec2.internal --ignore-daemonsets --delete-local-data --force


aws eks list-nodegroups --cluster-name tig-2517-ec2-version-upd --region us-east-1


cluster_name="tig-2517-ec2-version-upd"
region="us-east-1"
nodegroups=$(aws eks list-nodegroups --cluster-name $cluster_name --region $region --output json | jq -r '.nodegroups[]')
for nodegroup in $nodegroups; do
    version=$(aws eks describe-nodegroup --cluster-name $cluster_name --nodegroup-name mg_5-2023120811020280720000000f --region $region --output json | jq -r '.nodegroup.nodegroupVersion')
    echo "Nodegroup: $nodegroup, Version: $version"
done


cluster_name="tig-2517-ec2-version-upd"
region="us-east-1"
nodegroups=$(aws eks list-nodegroups --cluster-name $cluster_name --region $region --output json | jq -r '.nodegroups[]')
for nodegroup in $nodegroups; do
    version=$(aws eks describe-nodegroup --cluster-name $cluster_name --nodegroup-name $nodegroup --region $region --output json | jq -r '.nodegroup.nodegroupVersion')
    echo "Nodegroup: $nodegroup, Version: $version"
done

kubectl get nodes -l eks.amazonaws.com/nodegroup=mg_5-2023120811020280720000000f  --no-headers=true -o custom-columns=":metadata.name"

aws eks list-nodegroups --cluster-name tig-2517-ec2-version-upd --region us-east-1 --output json | jq -r '.nodegroups[]'

aws eks describe-addon-versions --addon-name vpc-cni --kubernetes-version 1.28
aws eks update-addon --cluster-name tig-2517-ec2-version-upd --addon-name vpc-cni --addon-version v1.13.4-eksbuild.1 --resolve-conflicts OVERWRITE 

aws eks --region us-east-1 update-kubeconfig --name tig-2517-ec2-version-upd  --role-arn arn:aws:iam::622268126582:role/tig-2517-ec2-version-upd-admin-access

kubectl apply -f ./utils/ingress/full-demo.yml
kubectl get pods -n demo-ns --watch
kubectl get ingress -n demo-ns

aws eks --region us-east-1 update-kubeconfig --name tig-2517-ec2-version-upd  --role-arn arn:aws:iam::622268126582:role/tig-2517-ec2-version-upd-admin-access"
eksctl delete nodegroup --region <your-region> --cluster <your-cluster-name> --name <your-nodegroup-name>

kubectl get pods -n kube-system
kubectl logs pod/aws-load-balancer-controller-84b7b67d7c-lvhrs -n kube-system

aws eks describe-addon-versions --cluster-name <your-cluster-name> --region <your-region> --addon-name vpc-cni --kubernetes-version 1.28
aws eks describe-update --name tig-2517-ec2-version-upd --region us-east-1 --addon-name vpc-cni