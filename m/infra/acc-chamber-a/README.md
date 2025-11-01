# chamber-a Account Infrastructure

Account-specific Terraform configuration for the chamber organization's a account.

## Usage

```bash
cd infra/acc-chamber-a
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-a/terraform.tfstate`)
- **Profile**: `chamber-a`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
