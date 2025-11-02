## Account-specific Terraform: helix-ci

```bash
cd infra/acc-helix-ci
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
