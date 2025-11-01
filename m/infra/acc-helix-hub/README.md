# helix-hub Account Infrastructure

Account-specific Terraform configuration for the helix organization's hub account.

## Usage

```bash
cd infra/acc-helix-hub
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-hub/terraform.tfstate`)
- **Profile**: `helix-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
