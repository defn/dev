## Account-specific Terraform: chamber-p

```bash
cd infra/acc-chamber-p
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
