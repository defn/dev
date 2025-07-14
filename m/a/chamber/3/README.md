# Chamber Environment: 3

AWS environment configuration for chamber-3 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-3
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/3
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
