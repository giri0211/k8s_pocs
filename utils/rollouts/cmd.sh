kubectl apply -f ./utils/rollouts/rollout-example.yml 
kubectl delete -f ./utils/rollouts/rollout-example.yml 

kubectl apply -f ./utils/vpa/vpa-on-rollout.yaml 
kubectl apply -f ./utils/vpa/vpa-on-rollout-with-resources.yml 

kubectl get pods --watch