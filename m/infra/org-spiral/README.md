# Spiral Organization Infrastructure

Organization-level Terraform configuration for the spiral AWS organization.

## Usage

```bash
cd infra/org-spiral
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/org-spiral/terraform.tfstate`)
- **Profile**: `spiral-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
