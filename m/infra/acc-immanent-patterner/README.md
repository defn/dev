# immanent-patterner Account Infrastructure

Account-specific Terraform configuration for the immanent organization's patterner account.

## Usage

```bash
cd infra/acc-immanent-patterner
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-immanent-patterner/terraform.tfstate`)
- **Profile**: `immanent-patterner`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
