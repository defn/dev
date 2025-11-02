## Account-specific Terraform: chamber-z

```bash
cd infra/acc-chamber-z
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
