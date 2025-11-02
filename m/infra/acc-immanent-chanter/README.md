## Account-specific Terraform: immanent-chanter

```bash
cd infra/acc-immanent-chanter
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
