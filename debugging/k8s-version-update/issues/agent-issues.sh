# get cluster version and nodes version
kubectl version
kubectl get nodes

export AWS_PROFILE=phr-sandbox
echo $AWS_PROFILE
aws sso login

export AWS_PROFILE=phr-platform-dev
echo $AWS_PROFILE
aws sso login


# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::545444110299:role/csa-deployments-csa-eks-admin-access

# smart-on-fhir
 
#  platform-dev agent issues

# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/smart-on-fhir-eks-admin-access --role-session-name cluster-admin-fhir
# # Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name smart-on-fhir  --role-arn arn:aws:iam::545444110299:role/smart-on-fhir-eks-admin-access

# cicd cluster
aws sts assume-role --role-arn arn:aws:iam::622268126582:role/cicd-dev-eks-cluster-admin-access --role-session-name cluster-admin-cicd
aws eks --region us-east-1 update-kubeconfig --name cicd-dev-eks-cluster --role-arn arn:aws:iam::622268126582:role/cicd-dev-eks-cluster-admin-access

# csa-deployments
aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin-cicd
aws eks --region us-east-1 update-kubeconfig --name csa-deployments --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access


aws eks --region us-east-1 update-kubeconfig --name tig-4570-blueprints-v5-upd 


kubectl get pods -n grafana-agent
kubectl logs pod/grafana-agent-0   -n grafana-agent --since=5m
kubectl logs pod/grafana-agent-traces-6d5b5686b5-tz7xz   -n grafana-agent --since=10m

kubectl get pvc -n grafana-agent
kubectl get pv -n grafana-agent

kubectl get pods -n grafana-agent --show-labels

kubectl get deploy -n grafana-agent
kubectl get rs -n grafana-agent

kubectl delete pod -l statefulset.kubernetes.io/pod-name=grafana-agent-0 -n grafana-agent


kubectl rollout restart deploy grafana-agent-traces ksm-release-kube-state-metrics  -n grafana-agent

kubectl get ns
kubectl get deploy -n external-dns
kubectl get pods -n kube-system --watch

aws eks --region us-east-1 update-kubeconfig --name tig-4422-ep-access  --role-arn arn:aws:iam::622268126582:role/tig-4422-ep-access-admin-access
aws eks --region us-east-1 update-kubeconfig --name onboarding-ue  --role-arn arn:aws:iam::545444110299:role/onboarding-ue-user-enablement-eks-admin-access
aws eks --region us-east-1 update-kubeconfig --name onboarding-ue  --role-arn arn:aws:iam::545444110299:role/onboarding-ue-user-enablement-eks-admin-access



kubectl version
kubectl get nodes

# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
aws eks describe-addon --cluster-name tig-4422-ep-access --addon-name vpc-cni --query addon.addonVersion --output text
aws eks describe-addon --cluster-name tig-4422-ep-access --addon-name coredns --query addon.addonVersion --output text
aws eks describe-addon --cluster-name tig-4422-ep-access --addon-name kube-proxy --query addon.addonVersion --output text

# with v1.27 k8s verison
# vpc-cni v1.15.4-eksbuild.1
# coredns v1.10.1-eksbuild.1
# kube-proxy  v1.27.1-eksbuild.1

# update the vpc-cni add-on version one minor version at a time from current version v1.12.5-eksbuild.2

aws eks update-addon --cluster-name tig-4422-ep-access --addon-name vpc-cni --addon-version v1.12.5-eksbuild.2 `
    --resolve-conflicts OVERWRITE
# v1.26
# v1.12.5-eksbuild.2

# v1.27
# v1.12.6-eksbuild.2

# v1.28
# v1.14.1-eksbuild.1


aws eks update-addon --cluster-name csa-deployments --addon-name vpc-cni --addon-version v1.13.4-eksbuild.1 --resolve-conflicts OVERWRITE 


aws eks update-addon --cluster-name tig-4422-ep-access --addon-name vpc-cni --addon-version v1.13.4-eksbuild.1 `
    --resolve-conflicts OVERWRITE --configuration-values '{"env":{ "ENABLE_POD_ENI" : "true"}}'

aws eks update-addon --cluster-name tig-4422-ep-access --addon-name vpc-cni --addon-version v1.14.1-eksbuild.1 `
    --resolve-conflicts OVERWRITE --configuration-values '{"env":{ "ENABLE_POD_ENI" : "true"}}'

aws eks update-addon --cluster-name tig-4422-ep-access --addon-name vpc-cni --addon-version v1.15.1-eksbuild.1 `
    --resolve-conflicts OVERWRITE --configuration-values '{"env":{ "ENABLE_POD_ENI" : "true"}}'

kubectl get daemonset -n kube-system
kubectl get daemonset aws-node -n kube-system -o yaml

kubectl get deploy -n kube-system

kubectl rollout restart deploy aws-load-balancer-controller coredns metrics-server -n kube-system
kubectl rollout restart deploy external-dns -n external-dns

# force delete pvc

kubectl delete pvc agent-wal-grafana-agent-0 -n grafana-agent --force --grace-period=0
kubectl delete pod grafana-agent-0 -n grafana-agent --force --grace-period=0
kubeclt edit pvc

kubectl get pvc -n grafana-agent

kubectl get ns
kubectl get all -n aws-for-fluent-bit


# aws eks --region us-east-1 update-kubeconfig --name tig-4570-blueprints-v5-upd
aws eks --region us-east-1 update-kubeconfig --name csa-deployments


kubectl edit pvc agent-wal-grafana-agent-0 -n grafana-agent


kubectl get pvc agent-wal-grafana-agent-0 -n grafana-agent -o json | \
  jq 'del(.metadata.finalizers)' | \
  kubectl replace --raw "/api/v1/namespaces/grafana-agent/persistentvolumeclaims/agent-wal-grafana-agent-0" -f -

  kubectl patch pvc agent-wal-grafana-agent-0 -n grafana-agent --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'


finalizers:
  - kubernetes.io/pvc-protection

"finalizers": [
      "kubernetes.io/pvc-protection"
    ],


kubectl get sc





