
aws eks --region us-east-1 update-kubeconfig --name csa-deployments
arn:aws:iam::622268126582:policy/csa-deployments-csa-eks-admin-administrator-access]


# force deletet the finalizers on the namespace before deleting the namespace.
NAMESPACE=test-ns2
kubectl get namespace $NAMESPACE -o json | sed 's/"kubernetes"//' | kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f -


kubectl create ns test-ns1
kubectl create ns test-ns2

# kubectl get ns


kubectl apply -f ./utils/busybox/network-check.yml -n test-ns1
kubectl apply -f ./utils/busybox/network-check.yml -n test-ns2


kubectl get pods -n test-ns1
kubectl get pods -n test-ns2

kubectl edit ns test-ns
kubectl delete ns test-ns1 test-ns2



