# Chamber Environment: 6

AWS environment configuration for chamber-6 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-6
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/6
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
