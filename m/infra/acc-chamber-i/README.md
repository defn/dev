# chamber-i Account Infrastructure

Account-specific Terraform configuration for the chamber organization's i account.

## Usage

```bash
cd infra/acc-chamber-i
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-i/terraform.tfstate`)
- **Profile**: `chamber-i`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
