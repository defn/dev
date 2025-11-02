## Usage: Account-specific Terraform: spiral-hub

```bash
cd infra/acc-spiral-hub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
