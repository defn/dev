# chamber-4 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 4 account.

## Usage

```bash
cd infra/acc-chamber-4
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-4/terraform.tfstate`)
- **Profile**: `chamber-4`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
