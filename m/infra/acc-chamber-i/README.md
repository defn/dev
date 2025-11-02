## Usage: Account-specific Terraform: chamber-i

```bash
cd infra/acc-chamber-i
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
