## Account-specific Terraform: fogg-log

```bash
cd infra/acc-fogg-log
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
