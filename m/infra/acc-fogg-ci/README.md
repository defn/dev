## Account-specific Terraform: fogg-ci

```bash
cd infra/acc-fogg-ci
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
