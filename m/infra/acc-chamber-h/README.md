# chamber-h Account Infrastructure

Account-specific Terraform configuration for the chamber organization's h account.

## Usage

```bash
cd infra/acc-chamber-h
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-h/terraform.tfstate`)
- **Profile**: `chamber-h`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
