export AWS_PROFILE=phr-sandbox
echo $AWS_PROFILE
aws sso login



# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin1
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access


kubectl get pods -n grafana-agent -o wide

kubectl delete pod grafana-agent-0 -n grafana-agent
kubectl logs pod/grafana-agent-0   -n grafana-agent --since=2m