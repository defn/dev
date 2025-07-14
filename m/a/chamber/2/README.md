# Chamber Environment: 2

AWS environment configuration for chamber-2 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-2
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/2
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
