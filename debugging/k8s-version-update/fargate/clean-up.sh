# Assume Admin role and with Admin Access on the EKS cluster, example command given below

# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access

kubectl get all -n external-dns
kubectl get sa -n external-dns
kubectl delete sa external-dns-sa -n external-dns
kubectl get sa -n kube-system

kubectl delete deploy external-dns -n external-dns
kubectl delete sa external-dns-sa -n external-dns
kubectl delete ns aws-observability
kubectl delete sa aws-load-balancer-controller-sa -n kube-system

kubectl get ns

kubectl get all -n aws-observability


kubectl delete sa external-dns-sa -n external-dns

kubectl get pods -n kube-system
helm list -n external-dns

helm status metrics-server -n kube-system

helm delete aws-load-balancer-controller -n kube-system


helm delete metrics-server -n kube-system
helm delete vpa -n vpa
helm delete external-dns -n external-dns

kubectl get all -n external-dns | grep external-dns

kubectl delete service/external-dns -n external-dns

kubectl get ns
helm list -n external-dns
kubectl delete -n external-dns --force 

kubectl delete namespace  external-dns --force --grace-period=0



helm list -n external-dns

kubectl describe deployment metrics-serve -n kube-system
helm version

helm delete metrics-server --purge -n kube-system

kubectl config current-context



