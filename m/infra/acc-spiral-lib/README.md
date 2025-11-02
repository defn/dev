## Account-specific Terraform: spiral-lib

```bash
cd infra/acc-spiral-lib
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
