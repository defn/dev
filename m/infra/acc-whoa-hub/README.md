## Usage: Account-specific Terraform: whoa-hub

```bash
cd infra/acc-whoa-hub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
