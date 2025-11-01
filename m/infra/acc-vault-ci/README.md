# vault-ci Account Infrastructure

Account-specific Terraform configuration for the vault organization's ci account.

## Usage

```bash
cd infra/acc-vault-ci
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-vault-ci/terraform.tfstate`)
- **Profile**: `vault-ci`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
