inframap generate ./debugging/inframap/terraform.tfstate | dot -Tpng > state.png

inframap generate ./debugging/inframap/terraform.tfstate | graph-easy

terraform graph ./debugging/tf/aws_secret

inframap generate terraform.tfstate | dot -Tpng > state.png