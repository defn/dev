# Spiral Environment Configurations

Spiral tool environment configurations with AWS profile setups.

## Environments

- `ci/` - CI environment (spiral-ci profile)
- `dev/` - Development environment (spiral-dev profile)
- `hub/` - Hub environment (spiral-hub profile)
- `lib/` - Library environment (spiral-lib profile)
- `log/` - Logging environment (spiral-log profile)
- `net/` - Network environment (spiral-net profile)
- `ops/` - Operations environment (spiral-ops profile)
- `org/` - Organization environment (spiral-org profile)
- `prod/` - Production environment (spiral-prod profile)
- `pub/` - Public environment (spiral-pub profile)

Each environment contains mise.toml with AWS profile configuration and SSO authentication hooks.