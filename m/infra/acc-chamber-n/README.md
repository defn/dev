# chamber-n Account Infrastructure

Account-specific Terraform configuration for the chamber organization's n account.

## Usage

```bash
cd infra/acc-chamber-n
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-n/terraform.tfstate`)
- **Profile**: `chamber-n`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
