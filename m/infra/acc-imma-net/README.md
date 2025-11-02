## Account-specific Terraform: imma-net

```bash
cd infra/acc-imma-net
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
