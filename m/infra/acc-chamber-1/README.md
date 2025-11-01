# chamber-1 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 1 account.

## Usage

```bash
cd infra/acc-chamber-1
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-1/terraform.tfstate`)
- **Profile**: `chamber-1`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
