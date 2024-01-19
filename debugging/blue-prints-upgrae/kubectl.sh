export AWS_PROFILE=phr-platform-dev
echo $AWS_PROFILE
aws sso login


aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd

# like admin wiht out role
aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd
kubectl get pods,nodes
kubectl get ns

# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::622268126582:role/team-blue-team-2023122107420699070000000d


# Assume the cluster app team role
aws sts assume-role --role-arn arn:aws:iam::622268126582:role/team-blue-team-2023122107420699070000000d --role-session-name cluster-app-team
# # Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd  --role-arn arn:aws:iam::622268126582:role/team-blue-team-2023122107420699070000000d
kubectl get pods,nodes #error: You must be logged in to the server (Unauthorized)
kubectl get pods -n team-blue

aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd  --role-arn arn:aws:iam::622268126582:role/tig-4407-blueprints-v5-upd-team-blue-access
kubectl get pods # fails
kubectl get pods -n team-blue

aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd  --role-arn arn:aws:iam::622268126582:role/tig-4407-blueprints-v5-upd-admin-access

aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd  --role-arn arn:aws:iam::622268126582:role/tig-4407-blueprints-v5-upd-admin-administrator-access
kubectl get pods

kubectl edit configmap aws-auth -n kube-system

kubectl get pvc -n grafana-agent
kubectl edit pvc agent-wal-grafana-agent-0 -n grafana-agent
