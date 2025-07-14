# m/cache/

Caching infrastructure setup for development and build acceleration.

## Contents

### Infrastructure Configuration
- **docker-compose.yaml** - Cache services orchestration (registry, proxy, etc.)
- **Makefile** - Cache infrastructure management
  - `init` - Initialize cache directories and SSL certificates
  - `up` - Start Docker compose services
  - `serve` - Expose cache services via Tailscale

### Configuration
- **.gitignore** - Excludes cache data and temporary files

### Subdirectories
- **docker/** - Docker registry configuration and certificates
- **proxy/** - Proxy configuration (Squid)

This caching infrastructure improves build performance by providing local registries, proxies, and shared build caches for development workflows.