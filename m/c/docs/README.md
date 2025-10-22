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
│   │   └── docs/        # Documentation markdown files
│   │       ├── index.mdx
│   │       ├── guides/
│   │       └── reference/
│   └── content.config.ts
├── astro.config.mjs     # Astro configuration
├── package.json         # Dependencies and scripts
└── tsconfig.json        # TypeScript configuration
```

## Writing Documentation

Add new documentation pages as `.md` or `.mdx` files in `src/content/docs/`. The file structure determines the URL:

- `src/content/docs/index.mdx` → `/`
- `src/content/docs/guides/example.md` → `/guides/example`
- `src/content/docs/reference/example.md` → `/reference/example`

See the [Starlight documentation](https://starlight.astro.build/) for more details on authoring content.

## Troubleshooting

### Development server blocked

If you see an error about blocked hosts when accessing the dev server, verify that `astro.config.mjs` includes the Vite server configuration with your workspace domain in `allowedHosts`.

### Module not found errors

Run `npm install` to ensure all dependencies are installed.
