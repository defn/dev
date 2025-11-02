## Account-specific Terraform: whoa-org

```bash
cd infra/acc-whoa-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
