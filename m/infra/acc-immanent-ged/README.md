# immanent-ged Account Infrastructure

Account-specific Terraform configuration for the immanent organization's ged account.

## Usage

```bash
cd infra/acc-immanent-ged
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-ged/terraform.tfstate`)
- **Profile**: `immanent-ged`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
