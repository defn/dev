## Account-specific Terraform: chamber-8

```bash
cd infra/acc-chamber-8
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
