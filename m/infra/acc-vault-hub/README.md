## Usage: Account-specific Terraform: vault-hub

```bash
cd infra/acc-vault-hub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
