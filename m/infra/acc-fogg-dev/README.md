# fogg-dev Account Infrastructure

Account-specific Terraform configuration for the fogg organization's dev account.

## Usage

```bash
cd infra/acc-fogg-dev
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-dev/terraform.tfstate`)
- **Profile**: `fogg-dev`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
