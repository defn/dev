# Chamber Environment: i

AWS environment configuration for chamber-i profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-i
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/i
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
