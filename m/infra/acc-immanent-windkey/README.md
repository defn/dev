# immanent-windkey Account Infrastructure

Account-specific Terraform configuration for the immanent organization's windkey account.

## Usage

```bash
cd infra/acc-immanent-windkey
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-windkey/terraform.tfstate`)
- **Profile**: `immanent-windkey`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
