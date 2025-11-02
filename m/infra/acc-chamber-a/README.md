## Usage: Account-specific Terraform: chamber-a

```bash
cd infra/acc-chamber-a
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
