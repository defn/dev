# Fogg Environment Configurations

Fogg tool environment configurations with AWS profile setups.

## Environments

- `ci/` - CI environment (fogg-ci profile)
- `dev/` - Development environment (fogg-dev profile)
- `hub/` - Hub environment (fogg-hub profile)
- `lib/` - Library environment (fogg-lib profile)
- `log/` - Logging environment (fogg-log profile)
- `net/` - Network environment (fogg-net profile)
- `ops/` - Operations environment (fogg-ops profile)
- `org/` - Organization environment (fogg-org profile)
- `prod/` - Production environment (fogg-prod profile)
- `pub/` - Public environment (fogg-pub profile)

Each environment contains mise.toml with AWS profile configuration and SSO authentication hooks.