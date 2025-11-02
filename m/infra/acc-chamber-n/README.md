## Account-specific Terraform: chamber-n

```bash
cd infra/acc-chamber-n
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
