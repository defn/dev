## Account-specific Terraform: fogg-ops

```bash
cd infra/acc-fogg-ops
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
