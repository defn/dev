# defn-org Account Infrastructure

Account-specific Terraform configuration for the defn organization's org account.

## Usage

```bash
cd infra/acc-defn-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-defn-org/terraform.tfstate`)
- **Profile**: `defn-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
