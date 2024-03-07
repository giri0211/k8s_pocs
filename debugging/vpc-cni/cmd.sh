# Assume the cluster administrator role
# aws sts assume-role --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access --role-session-name cluster-admin
# # Update kubeconfig with cluster administrator role
# aws eks --region us-east-1 update-kubeconfig --name csa-deployments  --role-arn arn:aws:iam::622268126582:role/csa-deployments-csa-eks-admin-access

# Update vpc-cni add-on version to v1.13.4-eksbuild.1
aws eks update-addon --cluster-name [cluster-name] --region us-east-1 --addon-name vpc-cni --addon-version v1.13.4-eksbuild.1 --resolve-conflicts OVERWRITE
# Check the version after update
aws eks describe-addon --cluster-name csa-deployments --region us-east-1 --addon-name vpc-cni --query addon.addonVersion --output text

aws eks update-addon --cluster-name authentication --region us-east-1 --addon-name vpc-cni --addon-version v1.14.1-eksbuild.1 --resolve-conflicts OVERWRITE


kubectl get daemonset --namespace kube-system
kubectl describe daemonset aws-node --namespace kube-system | grep amazon-k8s-cni: | cut -d : -f 3


aws eks describe-addon \
        --region us-east-1 \
        --addon-name vpc-cni \
        --query addon.addonVersion \
        --output text \
        --cluster-name tig-4829-ec2-nodes

aws eks describe-addon-versions \
    --addon-name vpc-cni \
    --region us-east-1 \
    --query "addons[].addonVersions[].[addonVersion, compatibilities[].defaultVersion]" \
    --output text \
    --kubernetes-version 1.26

aws eks describe-addon-versions \
    --addon-name vpc-cni \
    --kubernetes-version 1.26 \
    --region "us-east-1" \
    --query "addons[].addonVersions[].compatibilities[?defaultVersion == 'true'].addonVersion" \
    --output text


    aws eks describe-addon-versions \
    --addon-name vpc-cni \
    --kubernetes-version 1.26 \
    --query "addons[].addonVersions[].[addonVersion, compatibilities[].defaultVersion]" \
    --output text


    aws eks describe-addon-versions \
        --addon-name vpc-cni \
        --kubernetes-version 1.26 \
        --query "addons[].addonVersions[].compatibilities[?defaultVersion == 'true'].addonVersion" \
        --output text


aws eks describe-addon-versions --addon-name vpc-cni --kubernetes-version 1.21 --query 'addons[].addonVersions[0].version

# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html#vpc-add-on-self-managed-update

aws eks describe-addon-versions --addon-name vpc-cni --kubernetes-version 1.26 --query 'addons[].addonVersions[0].version' --output text
aws eks --region us-east-1 update-kubeconfig --name tig-4723-vpc-cni

aws eks describe-addon --cluster-name tig-4723-vpc-cni --region us-east-1 --addon-name vpc-cni --query addon.addonVersion --output text
