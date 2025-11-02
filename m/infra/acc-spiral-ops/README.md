## Account-specific Terraform: spiral-ops

```bash
cd infra/acc-spiral-ops
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
