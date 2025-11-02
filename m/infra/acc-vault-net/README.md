## Account-specific Terraform: vault-net

```bash
cd infra/acc-vault-net
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
