# Chamber AWS Organization

AWS SSO configuration for the chamber organization.

## Usage

Activate an account environment:

```bash
cd a/chamber/ops
mise trust
aws sts get-caller-identity
```

## Accounts

This organization contains 35 AWS account(s):

- `1/` - chamber-1 profile
- `2/` - chamber-2 profile
- `3/` - chamber-3 profile
- `4/` - chamber-4 profile
- `5/` - chamber-5 profile
- `6/` - chamber-6 profile
- `7/` - chamber-7 profile
- `8/` - chamber-8 profile
- `9/` - chamber-9 profile
- `a/` - chamber-a profile
- `b/` - chamber-b profile
- `c/` - chamber-c profile
- `d/` - chamber-d profile
- `e/` - chamber-e profile
- `f/` - chamber-f profile
- `g/` - chamber-g profile
- `h/` - chamber-h profile
- `i/` - chamber-i profile
- `j/` - chamber-j profile
- `l/` - chamber-l profile
- `m/` - chamber-m profile
- `n/` - chamber-n profile
- `o/` - chamber-o profile
- `org/` - chamber-org profile
- `p/` - chamber-p profile
- `q/` - chamber-q profile
- `r/` - chamber-r profile
- `s/` - chamber-s profile
- `t/` - chamber-t profile
- `u/` - chamber-u profile
- `v/` - chamber-v profile
- `w/` - chamber-w profile
- `x/` - chamber-x profile
- `y/` - chamber-y profile
- `z/` - chamber-z profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
