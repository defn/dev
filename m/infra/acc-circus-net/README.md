## Account-specific Terraform: circus-net

```bash
cd infra/acc-circus-net
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
