## Account-specific Terraform: chamber-b

```bash
cd infra/acc-chamber-b
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
