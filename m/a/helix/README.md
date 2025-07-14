# Helix Environment Configurations

Helix tool environment configurations with AWS profile setups.

## Environments

- `ci/` - CI environment (helix-ci profile)
- `dev/` - Development environment (helix-dev profile)
- `hub/` - Hub environment (helix-hub profile)
- `lib/` - Library environment (helix-lib profile)
- `log/` - Logging environment (helix-log profile)
- `net/` - Network environment (helix-net profile)
- `ops/` - Operations environment (helix-ops profile)
- `org/` - Organization environment (helix-org profile)
- `prod/` - Production environment (helix-prod profile)
- `pub/` - Public environment (helix-pub profile)

Each environment contains mise.toml with AWS profile configuration and SSO authentication hooks.