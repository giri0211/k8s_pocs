# get cluster version and nodes version
kubectl version
kubectl get nodes

aws eks --region us-east-1 update-kubeconfig --name tig-4422-ep-access

kubectl get pods -n grafana-agent
kubectl logs pod/grafana-agent-traces-6f44858f4b-4cgkv  -n grafana-agent

kubectl get pods -n grafana-agent --show-labels

kubectl get deploy -n grafana-agent
kubectl get rs -n grafana-agent

kubectl delete pod -l statefulset.kubernetes.io/pod-name=grafana-agent-0 -n grafana-agent


kubectl rollout restart deploy grafana-agent-traces ksm-release-kube-state-metrics  -n grafana-agent

kubectl get ns
kubectl get deploy -n external-dns
kubectl get pods -n kube-system --watch

aws eks --region us-east-1 update-kubeconfig --name tig-4422-ep-access  --role-arn arn:aws:iam::622268126582:role/tig-4422-ep-access-admin-access
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
kubectl get pvc -n grafana-agent






