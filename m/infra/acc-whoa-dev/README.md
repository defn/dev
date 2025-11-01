# whoa-dev Account Infrastructure

Account-specific Terraform configuration for the whoa organization's dev account.

## Usage

```bash
cd infra/acc-whoa-dev
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-whoa-dev/terraform.tfstate`)
- **Profile**: `whoa-dev`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
