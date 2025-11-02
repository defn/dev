## Usage: Account-specific Terraform: chamber-t

```bash
cd infra/acc-chamber-t
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
