## Usage: Account-specific Terraform: circus-log

```bash
cd infra/acc-circus-log
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
