## Account-specific Terraform: defn-org

```bash
cd infra/acc-defn-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
