## Account-specific Terraform: spiral-ci

```bash
cd infra/acc-spiral-ci
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
