## Account-specific Terraform: jianghu-net

```bash
cd infra/acc-jianghu-net
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
