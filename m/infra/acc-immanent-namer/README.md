## Account-specific Terraform: immanent-namer

```bash
cd infra/acc-immanent-namer
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
