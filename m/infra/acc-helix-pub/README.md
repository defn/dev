## Account-specific Terraform: helix-pub

```bash
cd infra/acc-helix-pub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
