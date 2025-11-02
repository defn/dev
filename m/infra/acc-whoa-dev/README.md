## Usage: Account-specific Terraform: whoa-dev

```bash
cd infra/acc-whoa-dev
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
