## Account-specific Terraform: fogg-hub

```bash
cd infra/acc-fogg-hub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
