#!/bin/bash

# "feature/tig-4502-check-cluster-access"
#             "feature/tig-4502-cluster-access-v2"
#             "feature/tig-4518-o11s-module-resource-updates"
#             "feature/tig-4570-teams-module-upgrade"
#             "feature/tig-4658-eks-module-upgrade-spike"
#             "feature/tig-4723-vpc-cni-addon-version"
#             "feature/tig-4787-vpc-addon-issue-fix"
#             "feature/tig-4860-document-cluster-upgrade"
#             "feature/tig-4900-eks-examples-on-sandbox-env"
#             "feature/tig-4981-document-dependencies"
#             "feature/tig-4991-vpa-endpoint-issue"
#             "feature/tig-4994-VP-webhook-config-v2"
#             "feature/tig-4994-vpa-webhook-config-latest"
#             "feature/tig-4994-vpa-webhook-config-v3"
#             "feature/tig-5114-admin-access"
#             "feature/tig-5411-admin-access-additional-iam-policy"

# List of branches to delete
branches=( "feature/tig-4502-cluster-access-v2"
            "feature/tig-4518-o11s-module-resource-updates"
            "feature/tig-4570-teams-module-upgrade"
            "feature/tig-4658-eks-module-upgrade-spike"
            "feature/tig-4723-vpc-cni-addon-version"
            "feature/tig-4787-vpc-addon-issue-fix"
            "feature/tig-4860-document-cluster-upgrade"
            "feature/tig-4900-eks-examples-on-sandbox-env"
            "feature/tig-4981-document-dependencies"
            "feature/tig-4991-vpa-endpoint-issue"
            "feature/tig-4994-VP-webhook-config-v2"
            "feature/tig-4994-vpa-webhook-config-latest"
            "feature/tig-4994-vpa-webhook-config-v3"
            "feature/tig-5114-admin-access"
            "feature/tig-5411-admin-access-additional-iam-policy" 
            )

# Delete local branches
for branch in "${branches[@]}"; do
    git branch -d "$branch"
done

# Delete remote branches
for branch in "${branches[@]}"; do
    git push origin --delete "$branch"
done
