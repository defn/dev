## Usage: Account-specific Terraform: whoa-pub

```bash
cd infra/acc-whoa-pub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
