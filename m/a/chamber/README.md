# Chamber Environment Configurations

Chamber tool environment configurations with AWS profile setups.

## Structure

This directory contains 35 environment configurations:
- Numeric environments: `1/` through `9/`
- Alphabetic environments: `a/` through `z/` (excluding `k/`)
- Organization environment: `org/`

Each subdirectory contains a `mise.toml` file with:
- AWS profile configuration (chamber-{environment})
- AWS region setting (us-west-2)
- AWS config file path
- SSO login hook for authentication

## Usage

Navigate to any environment directory to activate its AWS profile configuration through mise.