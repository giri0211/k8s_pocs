
# Get the cluster kubernetes version
latest_version=$(kubectl version | grep "Server Version" | cut -d " " -f 3)
echo "cluster version $latest_version"

kubectl delete pod grafana-agent-0 -n grafana-agent

kubectl get pods -n grafana-agent --watch

kubectl logs pod/grafana-agent-0   -n grafana-agent --since=2m


