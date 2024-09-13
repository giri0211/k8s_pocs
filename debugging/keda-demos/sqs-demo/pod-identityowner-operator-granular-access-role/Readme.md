# Keda

AWS IAM Roles for Service Accounts (IRSA) Pod Identity Webhook (documentation) allows you to provide the role name using an annotation on a service account associated with your pod.

You can tell KEDA to use AWS Pod Identity Webhook via podIdentity.provider

```yaml
podIdentity:
  provider: aws
  roleArn: <role-arn> # Optional.
  identityOwner: keda|workload
```

## Keda operator using IAM role with granular access to AWS SQS

You can override the default KEDA operator IAM role by specifying an roleArn parameter under the podIdentity field. This allows end-users to use different roles to access various resources which allows for more granular access than having a single **keda-operator** IAM role that has access to multiple resources.

### Setup process

below is the process
- All the AWS CLI commands, Kubenetes manifests used in the setup process are in the examples folder
    - [AWS CLI Commands](./keda-installation-commands.sh)

- Create keda-operator role, with trust policy, which allows **system:serviceaccount:keda:keda-operator** to assume the **keda-operator** IAM role
- Create AWS SQS granular access IAM role, with same trust policy as keda-operator, which allows **system:serviceaccount:keda:keda-operator** to assume the **keda-operator** IAM role.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::545444110299:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/E9593BA1E15E10C4020425FDA0017E4B"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.us-east-1.amazonaws.com/id/E9593BA1E15E10C4020425FDA0017E4B:sub": "system:serviceaccount:keda:keda-operator",
                    "oidc.eks.us-east-1.amazonaws.com/id/E9593BA1E15E10C4020425FDA0017E4B:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}

```

- Create AWS IAM policy to get attributes from AWS SQS queue

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "GetQueueAttributes",
                "Effect": "Allow",
                "Action": "sqs:GetQueueAttributes",
                "Resource": "arn:aws:sqs:us-east-1:545444110299:keda_poc_queue"
            }
        ]
    }

    ```
- Attach this SQS Access IAM policy to the **keda-operator-sqs-granual-access-role**
- install Keda helm chart with aws irsa enabled using the [keda-values.yaml](./keda-values-v2-15-irsa.yaml) file
- Create a service account for the workload, role-arn annotation to point to **keda-operator-sqs-granual-access-role**

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
    name: nginxdemo-sqs-granual-access-sa
    namespace: keda
    annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::545444110299:role/keda-operator-sqs-granual-access-role-tig6351
    ```

- Create a deployment using this service account

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: nginx-deployment-pod-sa
    labels:
        app: nginx-deployment-pod-sa
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: nginx-deployment-pod-sa
    template:
        metadata:
        labels:
            app: nginx-deployment-pod-sa
        spec:
        serviceAccountName: nginxdemo-sqs-granual-access-sa
        containers:
        - name: nginx-deployment-pod-sa
            image: nginx:latest
            ports:
            - containerPort: 80
        - name: aws-cli
            image: amazon/aws-cli:latest
            command: ["sh", "-c", "while true; do sleep 3600; done"]
            env:
            - name: AWS_DEFAULT_REGION
            value: us-east-1

    ```

- Create a AWS SQS scaler object, that targets this deployment and scale pods based on AWS SQS message count

    ```yaml
    apiVersion: keda.sh/v1alpha1
    kind: TriggerAuthentication
    metadata:
    name: sqs-pod-identityowner-trigger-auth
    spec:
    podIdentity:
        provider: aws # aws IRSA , KEDA operator to use sqs-granual-access-role instead of keda-operator role
        roleArn: "arn:aws:iam::545444110299:role/keda-operator-sqs-granual-access-role-tig6351"
        identityOwner: keda

    ---
    apiVersion: keda.sh/v1alpha1
    kind: ScaledObject
    metadata:
    name: sqsconsumer-hpa
    spec:
    scaleTargetRef:
        name: nginx-deployment-pod-sa
    minReplicaCount: 0
    maxReplicaCount: 10
    pollingInterval: 10
    cooldownPeriod:  10
    triggers:
    - type: aws-sqs-queue
        metadata:
        queueURL: https://sqs.us-east-1.amazonaws.com/545444110299/keda_poc_queue
        activationQueueLength: "0"
        queueLength: "2"
        awsRegion: us-east-1
        identityOwner: pod
        authenticationRef:
        name: "sqs-pod-identityowner-trigger-auth"
    ```
 **Note** > 
 `identityOwner` **keda** is configured to use the **keda-operator-sqs-granual-access-role-tig6351** IAM role instead of dfault **keda-operator** IAM role.

 ```yaml
   podIdentity:
        provider: aws # aws IRSA , KEDA operator to use sqs-granual-access-role instead of keda-operator role
        roleArn: "arn:aws:iam::545444110299:role/keda-operator-sqs-granual-access-role-tig6351"
        identityOwner: keda
```

- check the status of the scaler object and it should be ready with out any errors
- Send messages to the SQS Queue **keda_poc_queue**, which should scaled the deployment based on the message count.


