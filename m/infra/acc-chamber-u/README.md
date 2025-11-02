## Usage: Account-specific Terraform: chamber-u

```bash
cd infra/acc-chamber-u
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
