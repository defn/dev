# Documentation Site

This directory contains an Astro.js documentation site powered by Starlight.

## First-Time Setup

If this is your first time working with this project, you need to install the dependencies:

```bash
cd c/docs
npm install
```

This will install all required packages listed in `package.json`:

- `astro` - The Astro framework
- `@astrojs/starlight` - Starlight documentation theme
- `sharp` - Image optimization library

## Available Commands

All commands are run from the `c/docs/` directory:

### Development

```bash
npm run dev
```

Starts the development server at `http://localhost:4321` (or your Coder workspace URL). The site will automatically reload when you make changes to your content or configuration.

**Alias:** `npm start` does the same thing.

### Production Build

```bash
npm run build
```

Builds the site for production. The output will be in the `dist/` directory, ready to be deployed to any static hosting service.

### Preview Production Build

```bash
npm run preview
```

Starts a local server to preview your production build. Run this after `npm run build` to test the production build locally before deploying.

### Direct Astro CLI

```bash
npm run astro -- <command>
```

Run any Astro CLI command directly. Examples:

- `npm run astro -- add react` - Add React integration
- `npm run astro -- check` - Check for errors in your project

## Configuration

The site is configured in `astro.config.mjs`. Key configuration includes:

- **Vite Server Settings**: Configured to work with Coder workspace URLs (`*.defn.run`)
- **Starlight Integration**: Sidebar navigation, site title, and social links
- **Content Collections**: Defined in `src/content.config.ts`

## Project Structure

```
c/docs/
├── public/              # Static assets (favicon, images, etc.)
├── src/
│   ├── assets/          # Images and assets processed by Astro
│   ├── content/
│   │   ├── docs/        # Documentation markdown files
│   │   │   ├── index.mdx
│   │   │   ├── guides/
│   │   │   └── reference/
│   │   └── aws/         # AWS accounts JSON collection
│   │       ├── fogg/    # Example: organization subdirectory
│   │       │   ├── org.json
│   │       │   └── ops.json
│   │       └── helix-org.json
│   ├── pages/
│   │   └── aws/         # Pages for rendering AWS collection
│   │       ├── index.astro
│   │       └── [...slug].astro
│   └── content.config.ts
├── astro.config.mjs     # Astro configuration
├── package.json         # Dependencies and scripts
└── tsconfig.json        # TypeScript configuration
```

## Content Collections

### Docs Collection (Markdown)

Add new documentation pages as `.md` or `.mdx` files in `src/content/docs/`. The file structure determines the URL:

- `src/content/docs/index.mdx` → `/`
- `src/content/docs/guides/example.md` → `/guides/example`
- `src/content/docs/reference/example.md` → `/reference/example`

See the [Starlight documentation](https://starlight.astro.build/) for more details on authoring content.

### AWS Collection (YAML)

The `aws` collection contains YAML files describing AWS accounts. This collection is populated by the ACUTE pipeline:

1. `../unify.sh` - Consolidates CUE data from multiple sources
2. `../transform.sh` - Transforms CUE to YAML format
3. `npm run build` - Executes Astro.js to generate the documentation site

**Directory Structure → URL Mapping:**

The file path within `src/content/aws/` directly maps to the URL:

- `aws/fogg/org.yaml` → `/aws/fogg/org/`
- `aws/fogg/ops.yaml` → `/aws/fogg/ops/`
- `aws/helix-org.yaml` → `/aws/helix-org/`

**Supported Organization Styles:**

You can organize YAML files using either approach:

1. **Subdirectories** (grouped by organization): `aws/fogg/*.yaml`
2. **Flat files** (standalone accounts): `aws/account-name.yaml`
3. **Mixed** (both styles in the same collection)

**YAML Schema:**

Each AWS account YAML file must include:
- `name` (string, required) - Full account name (e.g., "fogg-org")
- `account` (string, required) - Account type (e.g., "org", "ops", "dev")
- `org` (string, required) - Organization name (e.g., "fogg", "helix")
- `id` (string, required) - AWS account ID
- `email` (string, required) - Must be valid email format
- `sso_role` (string, required) - SSO role name (e.g., "Administrator")

## Troubleshooting

### Module not found errors

Run `npm install` to ensure all dependencies are installed.
