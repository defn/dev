## Account-specific Terraform: fogg-pub

```bash
cd infra/acc-fogg-pub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
