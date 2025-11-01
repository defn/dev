# Coil AWS Organization

AWS SSO configuration for the coil organization.

## Usage

Activate an account environment:

```bash
cd a/coil/ops
mise trust
aws sts get-caller-identity
```

## Accounts

This organization contains 4 AWS account(s):

- `hub/` - coil-hub profile
- `lib/` - coil-lib profile
- `net/` - coil-net profile
- `org/` - coil-org profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
