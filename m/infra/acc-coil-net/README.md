# coil-net Account Infrastructure

Account-specific Terraform configuration for the coil organization's net account.

## Usage

```bash
cd infra/acc-coil-net
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-coil-net/terraform.tfstate`)
- **Profile**: `coil-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
