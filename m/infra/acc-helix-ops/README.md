## Usage: Account-specific Terraform: helix-ops

```bash
cd infra/acc-helix-ops
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
