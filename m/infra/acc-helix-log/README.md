## Usage: Account-specific Terraform: helix-log

```bash
cd infra/acc-helix-log
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
