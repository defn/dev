# coil-org Account Infrastructure

Account-specific Terraform configuration for the coil organization's org account.

## Usage

```bash
cd infra/acc-coil-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-coil-org/terraform.tfstate`)
- **Profile**: `coil-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
