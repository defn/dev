# Imma AWS Organization

AWS SSO configuration for the imma organization.

## Usage

Activate an account environment:

```bash
cd a/imma/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 6 AWS account(s):

- `org/` - imma-org profile
- `dev/` - imma-dev profile
- `lib/` - imma-lib profile
- `log/` - imma-log profile
- `net/` - imma-net profile
- `pub/` - imma-pub profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
