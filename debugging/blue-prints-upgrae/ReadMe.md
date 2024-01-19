# Migration to blueprints v5

- Update the type `kubernetes_namespace` to `kubernetes_namespace_v1` in the terraform.tfstate file for each application team namespace.

```json
{
  "module": "module.phreesia_eks.module.eks_teams[0]",
  "mode": "managed",
  "type": "kubernetes_namespace",
  "name": "team",
  "provider": "module.phreesia_eks.provider[\"registry.terraform.io/hashicorp/kubernetes\"]",
  "instances": [
    {
      "index_key": "team-blue"
    }
  ]
}
```
