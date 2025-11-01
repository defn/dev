# vault-pub Account Infrastructure

Account-specific Terraform configuration for the vault organization's pub account.

## Usage

```bash
cd infra/acc-vault-pub
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-pub/terraform.tfstate`)
- **Profile**: `vault-pub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
