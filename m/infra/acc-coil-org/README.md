## Account-specific Terraform: coil-org

```bash
cd infra/acc-coil-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
