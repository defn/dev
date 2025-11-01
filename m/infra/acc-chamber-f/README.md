# chamber-f Account Infrastructure

Account-specific Terraform configuration for the chamber organization's f account.

## Usage

```bash
cd infra/acc-chamber-f
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-f/terraform.tfstate`)
- **Profile**: `chamber-f`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
