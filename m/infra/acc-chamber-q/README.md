# chamber-q Account Infrastructure

Account-specific Terraform configuration for the chamber organization's q account.

## Usage

```bash
cd infra/acc-chamber-q
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-q/terraform.tfstate`)
- **Profile**: `chamber-q`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
