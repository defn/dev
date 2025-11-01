# chamber-c Account Infrastructure

Account-specific Terraform configuration for the chamber organization's c account.

## Usage

```bash
cd infra/acc-chamber-c
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-c/terraform.tfstate`)
- **Profile**: `chamber-c`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
