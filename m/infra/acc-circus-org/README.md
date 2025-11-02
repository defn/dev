## Account-specific Terraform: circus-org

```bash
cd infra/acc-circus-org
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
