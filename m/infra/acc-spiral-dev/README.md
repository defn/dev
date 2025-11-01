# spiral-dev Account Infrastructure

Account-specific Terraform configuration for the spiral organization's dev account.

## Usage

```bash
cd infra/acc-spiral-dev
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-dev/terraform.tfstate`)
- **Profile**: `spiral-dev`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
