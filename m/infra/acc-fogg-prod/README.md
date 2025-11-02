## Account-specific Terraform: fogg-prod

```bash
cd infra/acc-fogg-prod
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
