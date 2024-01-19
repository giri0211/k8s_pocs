terraform {
#   backend "s3" {
#     bucket         = "phr-platform-devterraform-state"
#     key            = "phreesia/platform/services/csa-deployments/aws/phr-platform-dev/us-east-1/csa-deploy-eks-cluster/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "your-dynamodb-lock-table"
#   }

 backend "local" {
    path = "./terraform.tfstate"
  }
}