/**
 * Vite Configuration for Webview Build
 *
 * Bundles the Svelte app into files the VS Code extension can load.
 *
 * ## Output Location
 *
 * Built files go to `../dist/` (extension root), not `webview/dist/`.
 * The extension's `localResourceRoots` points to this dist folder.
 *
 * ## Predictable Filenames
 *
 * Without `entryFileNames` and `assetFileNames`, Vite generates hashed
 * names like `webview-abc123.js`. The extension hardcodes paths:
 *
 *   vscode.Uri.joinPath(extensionUri, "dist", "webview.js")
 *
 * So we force stable names: `webview.js`, `webview.css`.
 *
 * ## Tailwind CSS
 *
 * Uses @tailwindcss/vite plugin (v4) instead of PostCSS config.
 * Custom theme colors (blood, abyss, gold) defined in app.css with
 * @theme directive.
 *
 * ## Svelte 5
 *
 * Uses runes mode ($state, $derived) for reactivity.
 * svelte.config.mjs enables TypeScript preprocessing.
 */

import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [svelte(), tailwindcss()],
  build: {
    // Output to extension's dist folder, not webview/dist
    outDir: "../dist",
    // Clean dist folder before each build
    emptyOutDir: true,
    rollupOptions: {
      output: {
        // Stable filenames (no content hashes) for extension to reference
        entryFileNames: "webview.js",
        assetFileNames: "webview.[ext]",
      },
    },
  },
});
