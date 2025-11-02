## Account-specific Terraform: chamber-l

```bash
cd infra/acc-chamber-l
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
