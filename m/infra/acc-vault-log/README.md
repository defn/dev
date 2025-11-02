## Account-specific Terraform: vault-log

```bash
cd infra/acc-vault-log
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
