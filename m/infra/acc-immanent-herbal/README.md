# immanent-herbal Account Infrastructure

Account-specific Terraform configuration for the immanent organization's herbal account.

## Usage

```bash
cd infra/acc-immanent-herbal
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-herbal/terraform.tfstate`)
- **Profile**: `immanent-herbal`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
