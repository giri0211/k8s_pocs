helm repo add aerokube https://charts.aerokube.com/
helm repo update
helm search repo aerokube

# helm upgrade --install --set=moon.enabled.resources=false,service.externalIPs[0]=$(minikube ip) -n moon moon aerokube/moon

helm upgrade --install -n default moon aerokube/moon --values ./utils/moon-helm/moon-helm-values.yaml  --dry-run --debug > ./utils/moon-helm/dry-run.yml
helm upgrade --install --set=moon.enabled.resources=false -n default moon aerokube/moon --values ./utils/moon-helm/moon-helm-values.yaml --debug > ./utils/moon-helm/dry-run.yml

helm upgrade --install -n default moon aerokube/moon --values ./utils/moon-helm/moon-helm-values.yaml

kubectl apply -f ./utils/moon-helm/ingress.yml

aws eks --region us-east-1 update-kubeconfig --name ec2-o11y-test

helm uninstall moon -n default


kubectl apply -f https://github.com/aerokube/charts/blob/master/moon2/crds/moon.aerokube.com_browsersets.yaml

https://github.com/aerokube/charts/blob/master/moon2/crds/moon.aerokube.com_configs.yaml