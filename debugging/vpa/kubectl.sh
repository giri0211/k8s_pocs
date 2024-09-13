$env:AWS_PROFILE="phr-sandbox-aws-contractor-sandbox-rw"
$env:AWS_PROFILE="phr-sandbox-phr-infra-platform-sandbox-admin"
$env:AWS_PROFILE="phr-sandbox-infra-platform-engineer"

$env:AWS_PROFILE
aws sso login

# Assume the namespace access role csa-deployments-project-template-access
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-platform-showcase-access --role-session-name ns-access-1
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name pie-deployments-green --role-arn arn:aws:iam::545444110299:role/pie-deployments-green-platform-showcase-access

# pie-deployments-vpa
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/pie-deployments-vpa-platform-showcase-access --role-session-name ns-access-1
aws eks --region us-east-1 update-kubeconfig --name pie-deployments-vpa --role-arn arn:aws:iam::545444110299:role/pie-deployments-vpa-platform-showcase-access
aws eks --region us-east-1 update-kubeconfig --name example-vpa-tig-4991
aws eks --region us-east-1 update-kubeconfig --name example-vpa-tig-4991
kubectl get sgp -n superblocks

# get caller identity and current context on Kubernetes config
aws sts get-caller-identity
kubectl config current-context

kubectl get ns
kubectl get pods -A
kubectl get pods -n platform-showcase

kubectl get sgp -n vpa
kubectl get all -n vpa
kubectl get endpoints vpa-webhook
kubectl get pods -o wide
kubectl describe pod vpa-admission-controller-c9f944c9f-scqzl


kubectl get mutatingwebhookconfigurations
kubectl describe  mutatingwebhookconfigurations vpa-webhook-config  
kubectl logs svc/vpa-webhook -n vpa

helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install vpa fairwinds-stable/vpa --namespace vpa --create-namespace

helm install vpa-1 fairwinds-stable/vpa --namespace vpa-1 --create-namespace

helm test -n vpa vpa

curl vpa-webhook.default.svc