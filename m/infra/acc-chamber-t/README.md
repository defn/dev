# chamber-t Account Infrastructure

Account-specific Terraform configuration for the chamber organization's t account.

## Usage

```bash
cd infra/acc-chamber-t
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-t/terraform.tfstate`)
- **Profile**: `chamber-t`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
