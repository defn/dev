## Account-specific Terraform: whoa-net

```bash
cd infra/acc-whoa-net
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
