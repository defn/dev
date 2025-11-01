# imma-dev Account Infrastructure

Account-specific Terraform configuration for the imma organization's dev account.

## Usage

```bash
cd infra/acc-imma-dev
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-imma-dev/terraform.tfstate`)
- **Profile**: `imma-dev`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
