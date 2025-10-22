## Documentation

The `c/docs/` directory contains an Astro.js + Starlight documentation site.

- **Development**: Run `npm run dev` in the `c/docs/` directory to start the development server
- **Build**: Run `npm run build` to create a production build
- **Preview**: Run `npm run preview` to preview the production build locally

See [c/docs/README.md](c/docs/README.md) for detailed setup and usage instructions.

## AWS Organization Structure

This repository manages 14 AWS Organizations with ~145 AWS accounts.

### Preferred Account Layout (10 accounts)

The ideal AWS organization structure uses 10 accounts (the default AWS limit):

**Core Infrastructure (5 accounts):**
- **org**: Organization Master account (manages policies, delegates to ops)
- **log**: Logging account (receives logs from all accounts)
- **net**: Network account (shares subnets via Transit Gateway)
- **lib**: Library account (pushes/deploys/pulls shared resources)
- **hub**: Shared Services

**Work Environments (3 accounts):**
- **ops**: Administration/operations account (receives delegation from org)
- **ci**: CI/CD pipelines and builds
- **cde**: Cloud Development Environments

**Service Environments (2 accounts):**
- **dev**: Development environment
- **sandbox**: Sandbox for wild west experiments
- **prod**: Production environment
- **pub**: Public-facing services/DMZ/security

Note: Organizations typically choose 2 of the 3 work environment accounts and 2 of the 4 service environment accounts to stay within the 10-account limit.

### Organizations with Ideal 10-Account Structure

Four organizations implement the complete 10-account pattern:

1. **fogg**: Complete 10-account structure
2. **helix**: Complete 10-account structure
3. **spiral**: Complete 10-account structure
4. **vault**: Complete 10-account structure

### Infrastructure-Only Organizations

Five organizations contain only infrastructure accounts (subset of the ideal pattern):

- **circus** (5 accounts): org, lib, log, net, ops
- **coil** (4 accounts): org, hub, lib, net
- **curl** (4 accounts): org, hub, lib, net
- **gyre** (2 accounts): org, ops
- **jianghu** (3 accounts): org, log, net

### Special Purpose Organizations

- **defn** (1 account): Bootstrap IAM account only
- **chamber** (30 accounts): Large multi-environment organization
- **immanent** (12 accounts): Extended multi-account structure with Earthsea-themed account names
- **imma** (6 accounts): Miscellaneous
- **whoa** (4 accounts): Miscellaneous

### Delegation Pattern

All organizations follow the security best practice of delegating from the **org** (master) account to the **ops** account for day-to-day administration, avoiding direct use of the organization master account.

## Workflow: upgrade mise packages

1. Run make mise-list in your $HOME directory to see what packages need to be upgraded
2. Run the recommended mise commands at the end of the output (like mise use package@version)
3. If mise configuration files changed, use git to add and commit the changed config files with conventional commits format
