# chamber-b Account Infrastructure

Account-specific Terraform configuration for the chamber organization's b account.

## Usage

```bash
cd infra/acc-chamber-b
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-b/terraform.tfstate`)
- **Profile**: `chamber-b`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
