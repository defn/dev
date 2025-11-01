# Curl AWS Organization

AWS SSO configuration for the curl organization.

## Usage

Activate an account environment:

```bash
cd a/curl/ops
mise trust
aws sso login
aws sts get-caller-identity
```

## Accounts

This organization contains 4 AWS account(s):

- `hub/` - curl-hub profile
- `lib/` - curl-lib profile
- `net/` - curl-net profile
- `org/` - curl-org profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
