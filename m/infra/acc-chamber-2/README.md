# chamber-2 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 2 account.

## Usage

```bash
cd infra/acc-chamber-2
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-2/terraform.tfstate`)
- **Profile**: `chamber-2`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
