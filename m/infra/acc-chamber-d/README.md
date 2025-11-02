## Account-specific Terraform: chamber-d

```bash
cd infra/acc-chamber-d
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
