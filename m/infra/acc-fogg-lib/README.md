## Usage: Account-specific Terraform: fogg-lib

```bash
cd infra/acc-fogg-lib
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
