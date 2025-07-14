# Chamber Environment: 1

AWS environment configuration for chamber-1 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-1
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/1
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
