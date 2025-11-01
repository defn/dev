# Coil Organization Infrastructure

Organization-level Terraform configuration for the coil AWS organization.

## Usage

```bash
cd infra/org-coil
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/org-coil/terraform.tfstate`)
- **Profile**: `coil-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
