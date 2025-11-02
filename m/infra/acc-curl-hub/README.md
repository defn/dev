## Account-specific Terraform: curl-hub

```bash
cd infra/acc-curl-hub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
