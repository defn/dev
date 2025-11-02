## Account-specific Terraform: chamber-y

```bash
cd infra/acc-chamber-y
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
