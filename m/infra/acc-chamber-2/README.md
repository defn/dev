## Account-specific Terraform: chamber-2

```bash
cd infra/acc-chamber-2
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
