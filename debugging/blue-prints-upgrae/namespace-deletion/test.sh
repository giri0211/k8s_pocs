
# Get the cluster kubernetes version
latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3)
echo "cluster version $latest_version"

kubectl delete pod grafana-agent-0 -n grafana-agent

kubectl get pods -n grafana-agent --watch

kubectl logs pod/grafana-agent-0   -n grafana-agent --since=2m


aws eks --region us-east-1 update-kubeconfig --name tig-4646-csa-eks-2
kubectl get namespace platform-showcase -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/platform-showcase/finalize" -f -
kubectl delete ns platform-showcase --wait=false --force --grace-period=0

kubectl get namespace project-template -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/project-template/finalize" -f -
kubectl delete ns project-template --wait=false --force --grace-period=0

kubectl get ns --watch