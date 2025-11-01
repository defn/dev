# chamber-w Account Infrastructure

Account-specific Terraform configuration for the chamber organization's w account.

## Usage

```bash
cd infra/acc-chamber-w
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-w/terraform.tfstate`)
- **Profile**: `chamber-w`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
