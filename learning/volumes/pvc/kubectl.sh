network-check-6688bb55c-pv4gc

kubectl get pods --watch

# one time pod up for troubleshooting networking
kubectl run busybox --image busybox:1.28 --restart=Never --rm -it busybox -- sh
kubectl logs pod/network-check-6688bb55c-nbxm5
kubectl 
kubectl delete pod/busybox -- /bin/sh

kubectl get events --field-selector involvedObject.name=network-check --sort-by='.metadata.creationTimestamp'
kubectl get events --field-selector involvedObject.name=efs-sc-test --sort-by='.metadata.creationTimestamp'

kubectl describe pvc example-pvc
#   ----    ------                ----                   ----                         -------
#   Normal  ExternalProvisioning  2m7s (x26 over 8m13s)  persistentvolume-controller  Waiting for a volume to be created either by the external provisioner 'efs.csi.aws.com' or manually by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.

kubectl get pods --all-namespaces | grep efs.csi.aws.com


kubectl get pods -l app=network-check -o wide --watch