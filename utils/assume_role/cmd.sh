aws sts get-caller-identity

# make sure the sso session role has the permission to assume the role
# in the aws config set the sso role name
# role phr-infra-platform-sandbox-admin does not have assume role permission.
[profile sandbox]
sso_session = sso
sso_account_id = 545444110299
sso_role_name = aws-contractor-sandbox-rw
region = us-east-1

aws sts assume-role --role-arn arn:aws:iam::545444110299:role/onboarding-ue-user-enablement-eks-admin-access --role-session-name ue-admin
# update kubeconfig with admin role
aws eks --region us-east-1 update-kubeconfig --name onboarding-ue --role-arn arn:aws:iam::545444110299:role/onboarding-ue-user-enablement-eks-admin-access
# admin have access to pods in default namespace
kubectl get pods

aws sts assume-role --role-arn arn:aws:iam::545444110299:role/onboarding-ue-scaling-access --role-session-name ue-scaling-ns
# update kubeconfig with namespace level access role
aws eks --region us-east-1 update-kubeconfig --name onboarding-ue --role-arn arn:aws:iam::545444110299:role/onboarding-ue-scaling-access
# have access only to team namespace
kubectl get pods -n scaling # works
kubectl get pods # fails
