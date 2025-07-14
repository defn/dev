# Vault Environment Configurations

Vault tool environment configurations with AWS profile setups.

## Environments

- `ci/` - CI environment (vault-ci profile)
- `dev/` - Development environment (vault-dev profile)
- `hub/` - Hub environment (vault-hub profile)
- `lib/` - Library environment (vault-lib profile)
- `log/` - Logging environment (vault-log profile)
- `net/` - Network environment (vault-net profile)
- `ops/` - Operations environment (vault-ops profile)
- `org/` - Organization environment (vault-org profile)
- `prod/` - Production environment (vault-prod profile)
- `pub/` - Public environment (vault-pub profile)

Each environment contains mise.toml with AWS profile configuration and SSO authentication hooks.