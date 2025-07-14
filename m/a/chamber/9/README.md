# Chamber Environment: 9

AWS environment configuration for chamber-9 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-9
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/9
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
