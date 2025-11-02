## Account-specific Terraform: fogg-dev

```bash
cd infra/acc-fogg-dev
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
