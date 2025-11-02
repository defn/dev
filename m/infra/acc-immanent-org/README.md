## Account-specific Terraform: immanent-org

```bash
cd infra/acc-immanent-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
