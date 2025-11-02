## Account-specific Terraform: chamber-o

```bash
cd infra/acc-chamber-o
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
