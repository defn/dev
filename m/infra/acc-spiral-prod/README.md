## Account-specific Terraform: spiral-prod

```bash
cd infra/acc-spiral-prod
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
