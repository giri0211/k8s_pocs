aws eks --region us-east-1 update-kubeconfig --name <clster_name>
kubectl get pods -n kube-system
# check core dns logs
kubectl logs -l eks.amazonaws.com/component=coredns -n=kube-system --since=60s
kubectl get deploy coredns -n kube-system -o yaml

# use busybox for cluster network troubleshooting
kubectl apply -f ./utils/busybox
kubectl exec -it pod/network-check-678776db5d-l74n6 -- /bin/sh
nslookup kubernetes.default
exit
kubectl delete -f ./utils/busybox

# one time pod up for troubleshooting networking
kubectl run busybox --image busybox:1.28 --restart=Never --rm -it busybox -- sh
kubectl logs pod/busybox
kubectl delete pod/busybox -- /bin/sh

kubectl get svc
kubectl get nodes 
kubectl get pods --watch
kubectl get --raw "/api/v1/nodes/ip-10-155-162-80.ec2.internal/proxy/logs/?query=kubelet"






