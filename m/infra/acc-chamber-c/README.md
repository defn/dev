## Account-specific Terraform: chamber-c

```bash
cd infra/acc-chamber-c
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
