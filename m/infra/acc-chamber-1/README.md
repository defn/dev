## Usage: Account-specific Terraform: chamber-1

```bash
cd infra/acc-chamber-1
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
