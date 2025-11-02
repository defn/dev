## Usage: Account-specific Terraform: helix-hub

```bash
cd infra/acc-helix-hub
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```
