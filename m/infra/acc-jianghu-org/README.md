## Account-specific Terraform: jianghu-org

```bash
cd infra/acc-jianghu-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
