# Chamber Environment: j

AWS environment configuration for chamber-j profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-j
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/j
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
