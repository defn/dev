# chamber-s Account Infrastructure

Account-specific Terraform configuration for the chamber organization's s account.

## Usage

```bash
cd infra/acc-chamber-s
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-s/terraform.tfstate`)
- **Profile**: `chamber-s`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
