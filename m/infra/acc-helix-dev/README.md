# helix-dev Account Infrastructure

Account-specific Terraform configuration for the helix organization's dev account.

## Usage

```bash
cd infra/acc-helix-dev
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-dev/terraform.tfstate`)
- **Profile**: `helix-dev`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
