## Account-specific Terraform: immanent-hand

```bash
cd infra/acc-immanent-hand
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
