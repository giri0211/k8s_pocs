# Overview

Use this busybox sample for toruble shooting the cluster dns issues.

## Kubectl commands

Below commands are helpful for torubleshooting the dns resolution issues.

```sh
aws eks --region us-east-1 update-kubeconfig --name [cluster_name]
kubectl get pods -n kube-system
# check core dns logs
kubectl logs -l eks.amazonaws.com/component=coredns -n=kube-system --since=60s
kubectl get deploy coredns -n kube-system -o yaml

# use busybox for cluster network troubleshooting
kubectl apply -f ./utils/busybox
kubectl exec -it pod/network-check-848455cd94-dfc7t -- /bin/sh

nslookup kubernetes.default
exit
kubectl delete -f ./utils/busybox

# one time pod up for troubleshooting networking
kubectl run busybox --image busybox:1.28 --restart=Never --rm -it busybox -- sh
kubectl run curl-test --image=curlimages/curl --restart=Never --rm -it -- sh
kubectl run mycurlpod --image=curlimages/curl -i --tty -- sh

kubectl exec -it pod/mycurlpod -- /bin/sh
curl google.com
curl https://google.com

kubectl get svc
kubectl get nodes 
kubectl get pods --watch
kubectl get --raw "/api/v1/nodes/ip-10-155-162-80.ec2.internal/proxy/logs/?query=kubelet"

```
