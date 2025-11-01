# chamber-8 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 8 account.

## Usage

```bash
cd infra/acc-chamber-8
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-8/terraform.tfstate`)
- **Profile**: `chamber-8`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
