# spiral-hub Account Infrastructure

Account-specific Terraform configuration for the spiral organization's hub account.

## Usage

```bash
cd infra/acc-spiral-hub
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-hub/terraform.tfstate`)
- **Profile**: `spiral-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
