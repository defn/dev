## Account-specific Terraform: immanent-ged

```bash
cd infra/acc-immanent-ged
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
