## Account-specific Terraform: immanent-herbal

```bash
cd infra/acc-immanent-herbal
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
