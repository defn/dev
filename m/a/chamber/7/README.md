# Chamber Environment: 7

AWS environment configuration for chamber-7 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-7
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/7
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
