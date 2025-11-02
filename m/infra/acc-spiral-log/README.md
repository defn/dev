## Account-specific Terraform: spiral-log

```bash
cd infra/acc-spiral-log
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
