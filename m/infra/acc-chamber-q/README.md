## Account-specific Terraform: chamber-q

```bash
cd infra/acc-chamber-q
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
