## Account-specific Terraform: vault-ci

```bash
cd infra/acc-vault-ci
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
