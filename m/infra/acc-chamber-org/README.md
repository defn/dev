# chamber-org Account Infrastructure

Account-specific Terraform configuration for the chamber organization's org account.

## Usage

```bash
cd infra/acc-chamber-org
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-org/terraform.tfstate`)
- **Profile**: `chamber-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
