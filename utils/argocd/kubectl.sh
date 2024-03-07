export AWS_CONFIG_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/ra_Girish.Tirumalase/.aws/credentials
export KUBECONFIG=/mnt/c/Users/ra_Girish.Tirumalase/.kube/config
export AWS_PROFILE=phr-sandbox-aws-contractor-sandbox-rw
echo $AWS_PROFILE 
echo $AWS_CONFIG_FILE 
echo $AWS_SHARED_CREDENTIALS_FILE
aws sso login


# Assume the cluster administrator role
aws sts assume-role --role-arn arn:aws:iam::545444110299:role/tig-2877-argocd-addon-csa-eks-admin-access --role-session-name cluster-admin
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name tig-2877-argocd-addon  --role-arn arn:aws:iam::545444110299:role/tig-2877-argocd-addon-csa-eks-admin-access


aws sts assume-role --role-arn arn:aws:iam::545444110299:role/tig-2977-eks-mgd-node-csa-eks-admin-access --role-session-name cluster-admin
# Update kubeconfig with cluster administrator role
aws eks --region us-east-1 update-kubeconfig --name tig-2977-eks-mgd-node  --role-arn arn:aws:iam::545444110299:role/tig-2977-eks-mgd-node-csa-eks-admin-access


aws eks --region us-east-1 update-kubeconfig --name tig-4622

tig-2977-eks-mgd-node

aws eks --region us-east-1 update-kubeconfig --name tig-2977-gitops-ec2



kubectl get pods -n argocd
kubectl get sgp -n argocd


kubectl apply -f ./utils/argocd/sealed-secrets-sample.yml
kubectl delete -f ./utils/argocd/sealed-secrets-sample.yml

kubectl apply -f ./utils/argocd/guest-book-sample.yml
kubectl delete -f ./utils/argocd/guest-book-sample.yml

kubectl apply -f ./utils/argocd/guestbook.yml


argocd proj list

kubectl get svc -n argocd
kubectl get pods -n argocd -v 6
kubectl get pods --watch

kubectl get sgp # sg-0bd1287e6fa8b175d
sg-0bd1287e6fa8b175d

kubectl config current-context 

kubectl get ns
kubectl get sgp -n argocd

kubectl delete ns argocd --force --grace-period=0

kubectl -n argocd get secret argocd-secret  -o jsonpath="{.data.admin\.password}" | base64 -d && echo
kubectl config set-context --current --namespace=argocd
kubectl config set-context --current --namespace=""


nslookup argo-cd-argocd-redis.argocd.svc.cluster.local

nslookup argo-cd-argocd-redis.argocd.svc.cluster.local
nslookup argo-cd-argocd-repo-server.argocd.svc.cluster.local
exit


argocd admin initial-password -n argocd

argocd login svc/argo-cd-argocd-server
argocd login localhost:8084

export ARGOCD_SERVER=localhost:8084
echo $ARGOCD_SERVER
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
argocd proj list