kubectl get sc
kubectl edit sc gp2

kubectl apply -f ./learning/volumes/pvc/ebs/pvc.yml --dry-run=client
kubectl get pvc 
kubectl get pv
kubectl describe pvc ebs-pvc-1


kubectl apply -f ./learning/volumes/pvc/ebs/statefulset-test2.yml 

kubectl delete -f ./learning/volumes/pvc/ebs/statefulset-test1.yml # --dry-run=client
kubectl delete pvc statefulset-test1-volume-statefulset-test1-0

kubectl apply -f ./learning/volumes/pvc/ebs/statefulset-test2.yml #--dry-run=client
kubectl get pods --watch
kubectl get events --field-selector involvedObject.name=nginx-volumes-2-nginx-statefulset-0  --sort-by='.metadata.creationTimestamp'

kubectl describe sa ebs-csi-controller-sa -n kube-system
aws eks describe-service-account --region us-east-1 --cluster-name tig-4623-ec2-drain-nodes --name ebs-csi-controller-sa --namespace kube-system

aws eks describe-service-account --help


kubectl delete -f ./learning/volumes/pvc/ebs/statefulset-test2.yml # --dry-run=client
kubectl delete pvc nginx-volumes-2-nginx-statefulset-0
kubectl get ns
kubectl get pods -n aws-ebs-csi-driver
kubectl delete pvc nginx-volumes-2-nginx-statefulset-0


kubectl delete -f ./learning/volumes/pvc/ebs/statefulset-test2.yml #--dry-run=client
kubectl delete pvc nginx-volumes-2-nginx-statefulset-0

kubectl get pods --watch

kubectl get events --field-selector involvedObject.name=ebs-pvc-1 --sort-by='.metadata.creationTimestamp'
kubectl get events --field-selector involvedObject.name=volume-test-ebs-pvc-1 --sort-by='.metadata.creationTimestamp'

# statefulset events
kubectl get events --field-selector involvedObject.name=statefulset-test1 --sort-by='.metadata.creationTimestamp'
# statefulset pod events
kubectl get events --field-selector involvedObject.name=statefulset-test1-0 --sort-by='.metadata.creationTimestamp'

# statefulset events
kubectl get events --field-selector involvedObject.name=nginx-statefulset --sort-by='.metadata.creationTimestamp'
# statefulset pod events
kubectl get events --field-selector involvedObject.name=nginx-statefulset-0 --sort-by='.metadata.creationTimestamp'
kubectl get events --field-selector involvedObject.name=nginx-volumes-2-nginx-statefulset-0  --sort-by='.metadata.creationTimestamp'
kubectl get events --field-selector involvedObject.name=statefulset-test1-volume-statefulset-test1-0  --sort-by='.metadata.creationTimestamp'

kubectl describe pvc statefulset-test1-volume-statefulset-test1-0
kubectl get pv

statefulset-test1-volume-statefulset-test1-0
 aws eks --region us-east-1 update-kubeconfig --name tig-4623-ec2-drain-nodes

kubectl get pods
kubectl describe pod statefulset-test1-0 
kubectl describe pod nginx-statefulset-0 

kubectl delete pvc statefulset-test1-volume-statefulset-test1-0
kubectl get statefulset
kubectl get pvc 
kubectl get pv

kubectl get sc
kubectl describe sc efs-sc