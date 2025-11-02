## Account-specific Terraform: chamber-5

```bash
cd infra/acc-chamber-5
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
