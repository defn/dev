## Account-specific Terraform: chamber-r

```bash
cd infra/acc-chamber-r
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
