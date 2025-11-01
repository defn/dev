# immanent-roke Account Infrastructure

Account-specific Terraform configuration for the immanent organization's roke account.

## Usage

```bash
cd infra/acc-immanent-roke
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-roke/terraform.tfstate`)
- **Profile**: `immanent-roke`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
