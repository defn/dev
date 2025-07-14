# Chamber Environment: n

AWS environment configuration for chamber-n profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-n
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/n
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
