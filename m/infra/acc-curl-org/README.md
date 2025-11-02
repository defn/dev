## Account-specific Terraform: curl-org

```bash
cd infra/acc-curl-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
