## Account-specific Terraform: chamber-9

```bash
cd infra/acc-chamber-9
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
