## Account-specific Terraform: immanent-doorkeeper

```bash
cd infra/acc-immanent-doorkeeper
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
