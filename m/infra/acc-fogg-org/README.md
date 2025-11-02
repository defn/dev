## Account-specific Terraform: fogg-org

```bash
cd infra/acc-fogg-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
