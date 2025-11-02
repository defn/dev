## Account-specific Terraform: chamber-x

```bash
cd infra/acc-chamber-x
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
