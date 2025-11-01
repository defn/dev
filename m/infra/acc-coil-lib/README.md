# coil-lib Account Infrastructure

Account-specific Terraform configuration for the coil organization's lib account.

## Usage

```bash
cd infra/acc-coil-lib
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-coil-lib/terraform.tfstate`)
- **Profile**: `coil-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
