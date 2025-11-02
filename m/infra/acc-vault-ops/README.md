## Account-specific Terraform: vault-ops

```bash
cd infra/acc-vault-ops
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
