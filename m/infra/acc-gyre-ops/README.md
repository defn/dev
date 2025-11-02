## Usage: Account-specific Terraform: gyre-ops

```bash
cd infra/acc-gyre-ops
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
