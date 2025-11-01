# coil-hub Account Infrastructure

Account-specific Terraform configuration for the coil organization's hub account.

## Usage

```bash
cd infra/acc-coil-hub
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-coil-hub/terraform.tfstate`)
- **Profile**: `coil-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
