## Account-specific Terraform: curl-lib

```bash
cd infra/acc-curl-lib
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
