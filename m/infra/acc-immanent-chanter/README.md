# immanent-chanter Account Infrastructure

Account-specific Terraform configuration for the immanent organization's chanter account.

## Usage

```bash
cd infra/acc-immanent-chanter
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-chanter/terraform.tfstate`)
- **Profile**: `immanent-chanter`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
