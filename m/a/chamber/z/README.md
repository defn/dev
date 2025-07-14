# Chamber Environment: z

AWS environment configuration for chamber-z profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-z
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/z
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
