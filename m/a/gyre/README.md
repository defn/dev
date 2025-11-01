# Gyre AWS Organization

AWS SSO configuration for the gyre organization.

## Usage

Activate an account environment:

```bash
cd a/gyre/ops
mise trust
aws sts get-caller-identity
```

## Accounts

This organization contains 2 AWS account(s):

- `ops/` - gyre-ops profile
- `org/` - gyre-org profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
