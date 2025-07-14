# Chamber Environment: u

AWS environment configuration for chamber-u profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-u
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/u
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
