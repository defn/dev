# chamber-z Account Infrastructure

Account-specific Terraform configuration for the chamber organization's z account.

## Usage

```bash
cd infra/acc-chamber-z
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-z/terraform.tfstate`)
- **Profile**: `chamber-z`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
