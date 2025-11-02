## Account-specific Terraform: helix-net

```bash
cd infra/acc-helix-net
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
