## Usage: Account-specific Terraform: circus-ops

```bash
cd infra/acc-circus-ops
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
