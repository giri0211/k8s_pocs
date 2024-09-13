 aws eks --region us-east-1 update-kubeconfig --name pie-aws-auth-fargate

kubectl apply -f ./utils/vpa/hamster.yml
kubectl delete -f ./utils/vpa/hamster.yml


kubectl apply -f ./utils/vpa/vpa-on-rollout-with-resources.yml
kubectl delete -f ./utils/vpa/vpa-on-rollout-with-resources.yml