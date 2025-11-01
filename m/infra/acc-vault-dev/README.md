# vault-dev Account Infrastructure

Account-specific Terraform configuration for the vault organization's dev account.

## Usage

```bash
cd infra/acc-vault-dev
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-dev/terraform.tfstate`)
- **Profile**: `vault-dev`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
