# vault-lib Account Infrastructure

Account-specific Terraform configuration for the vault organization's lib account.

## Usage

```bash
cd infra/acc-vault-lib
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-lib/terraform.tfstate`)
- **Profile**: `vault-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
