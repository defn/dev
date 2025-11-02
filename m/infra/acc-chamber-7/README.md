## Account-specific Terraform: chamber-7

```bash
cd infra/acc-chamber-7
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
