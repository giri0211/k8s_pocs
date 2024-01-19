aws eks --region us-east-1 update-kubeconfig --name csa-deployments

# Cluster control plane Kubernetes version
kubectl version | grep "Server Version"
# Check Node kubelet version
kubectl get nodes

kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'
kubectl get deployment -n sidecar-injector
