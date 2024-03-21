aws eks --region us-east-1 update-kubeconfig --name tig-4407-blueprints-v5-upd


 aws eks --region us-east-1 update-kubeconfig --name csa-deployments
kubectl get pods -n kube-system
# check core dns logs
kubectl logs -l eks.amazonaws.com/component=coredns -n=kube-system --since=60s
kubectl get deploy coredns -n kube-system -o yaml

kubectl create ns test-1
# Error from server (Forbidden): namespaces is forbidden: User "platform-showcase" cannot create resource "namespaces" in API group "" at the cluster scope

# use busybox for cluster network troubleshooting
kubectl apply -f ./
kubectl apply -f ./utils/busybox -n platform-showcase
# Error from server (Forbidden): error when creating "utils/busybox/network-check.yml": deployments.apps is forbidden: User "platform-showcase" cannot create resource "deployments" in API group "apps" in the namespace "platform-showcase"

kubectl exec -it pod/network-check-678776db5d-86wg6 -- /bin/sh
nslookup kubernetes.default.svc
nslookup google.com
nslookup mimir-nonprod.shared-services.phreesia.services
nslookup loki-nonprod.shared-services.phreesia.services
curl https://google.com
exit
kubectl delete -f ./utils/busybox
kubectl delete pod mycurlpod 
#curl
curl https://loki-nonprod.shared-services.phreesia.services
curl https://loki-nonprod.shared-services.phreesia.services/ready

# one time pod up for troubleshooting networking
kubectl run busybox --image busybox:1.28 --restart=Never --rm -it busybox -- sh
kubectl logs pod/busybox
kubectl delete pod/busybox -- /bin/sh

kubectl get ns
kubectl get svc
kubectl get nodes 
kubectl get pods --watch
kubectl get --raw "/api/v1/nodes/ip-10-155-162-80.ec2.internal/proxy/logs/?query=kubelet"

kubectl get pods --watch

    kubectl apply -f ./utils/busybox


kubectl run mycurlpod --image=curlimages/curl -i --tty -- sh
curl google.com



