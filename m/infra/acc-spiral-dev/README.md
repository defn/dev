## Account-specific Terraform: spiral-dev

```bash
cd infra/acc-spiral-dev
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
