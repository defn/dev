## Account-specific Terraform: immanent-roke

```bash
cd infra/acc-immanent-roke
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
