# immanent-doorkeeper Account Infrastructure

Account-specific Terraform configuration for the immanent organization's doorkeeper account.

## Usage

```bash
cd infra/acc-immanent-doorkeeper
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-doorkeeper/terraform.tfstate`)
- **Profile**: `immanent-doorkeeper`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
