## Account-specific Terraform: spiral-pub

```bash
cd infra/acc-spiral-pub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
