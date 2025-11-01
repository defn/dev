# chamber-x Account Infrastructure

Account-specific Terraform configuration for the chamber organization's x account.

## Usage

```bash
cd infra/acc-chamber-x
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-x/terraform.tfstate`)
- **Profile**: `chamber-x`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
