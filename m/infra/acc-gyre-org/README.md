## Account-specific Terraform: gyre-org

```bash
cd infra/acc-gyre-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
