# vault-org Account Infrastructure

Account-specific Terraform configuration for the vault organization's org account.

## Usage

```bash
cd infra/acc-vault-org
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-org/terraform.tfstate`)
- **Profile**: `vault-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
