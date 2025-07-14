# Circus Environment Configurations

Circus tool environment configurations with AWS profile setups.

## Environments

- `lib/` - Library environment (circus-lib profile)
- `log/` - Logging environment (circus-log profile)
- `net/` - Network environment (circus-net profile)
- `ops/` - Operations environment (circus-ops profile)
- `org/` - Organization environment (circus-org profile)

Each environment contains mise.toml with AWS profile configuration and SSO authentication hooks.