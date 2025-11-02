## Usage: Account-specific Terraform: vault-lib

```bash
cd infra/acc-vault-lib
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
