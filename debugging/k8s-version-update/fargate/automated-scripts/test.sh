aws eks --region us-east-1 update-kubeconfig --name csa-deployments-2
aws eks --region us-east-1 update-kubeconfig --name csa-deployments
export KUBERNETES_UPGRADE_VERSION=1.27
echo $KUBERNETES_UPGRADE_VERSION
kubectl get nodes | tail -n +2 | grep -v ${KUBERNETES_UPGRADE_VERSION}