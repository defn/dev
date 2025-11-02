## Account-specific Terraform: spiral-org

```bash
cd infra/acc-spiral-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
