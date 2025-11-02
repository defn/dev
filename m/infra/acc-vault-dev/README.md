## Usage: Account-specific Terraform: vault-dev

```bash
cd infra/acc-vault-dev
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
