## Account-specific Terraform: imma-pub

```bash
cd infra/acc-imma-pub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
