# chamber-v Account Infrastructure

Account-specific Terraform configuration for the chamber organization's v account.

## Usage

```bash
cd infra/acc-chamber-v
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-v/terraform.tfstate`)
- **Profile**: `chamber-v`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
