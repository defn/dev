## Account-specific Terraform: chamber-org

```bash
cd infra/acc-chamber-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
