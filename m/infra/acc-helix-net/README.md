# helix-net Account Infrastructure

Account-specific Terraform configuration for the helix organization's net account.

## Usage

```bash
cd infra/acc-helix-net
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-net/terraform.tfstate`)
- **Profile**: `helix-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
