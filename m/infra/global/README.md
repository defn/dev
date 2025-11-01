# Global Infrastructure

Cross-account and global AWS infrastructure resources.

## Usage

```bash
cd infra/global
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/global/terraform.tfstate`)
- **Profile**: `defn-org`
- **Provider**: AWS 5.99.1

## Resources

This directory contains Terraform configurations for global/cross-account resources that span multiple AWS organizations.
