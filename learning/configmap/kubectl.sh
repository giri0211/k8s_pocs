kubectl apply -f ./game-demo-config.yml
kubectl delete -f ./game-demo-config.yml

kubectl apply -f ./configmap-demo-pod.yml
kubectl delete -f ./configmap-demo-pod.yml

kubectl apply -f ./pod-with-configmap-reference.yml
kubectl delete -f ./pod-with-configmap-reference.yml


kubectl get pods --watch
kubectl describe pod configmap-demo-pod

kubectl exec -it pod/configmap-demo-pod -- /bin/sh


