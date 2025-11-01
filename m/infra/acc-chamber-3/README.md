# chamber-3 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 3 account.

## Usage

```bash
cd infra/acc-chamber-3
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-3/terraform.tfstate`)
- **Profile**: `chamber-3`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
