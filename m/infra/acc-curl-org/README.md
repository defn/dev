# curl-org Account Infrastructure

Account-specific Terraform configuration for the curl organization's org account.

## Usage

```bash
cd infra/acc-curl-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-curl-org/terraform.tfstate`)
- **Profile**: `curl-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
