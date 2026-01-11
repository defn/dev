# idiogloss

A VS Code extension that opens a global webview panel that tracks your current editor, showing file contents with live stats.

## Quick Start

```bash
# Install dependencies
pnpm install

# Build and install the extension
pnpm use
```

Then reload VS Code (Ctrl+Shift+P → "Developer: Reload Window").

## Usage

1. Open any file in the editor
2. Open the idiogloss panel using either:
   - Click the pig snout icon in the editor title bar (top right)
   - Keyboard shortcut (see below)
3. A **global panel** opens beside your editor
4. Switch between files — the panel automatically tracks the active editor
5. Edit any file — stats update in real-time

### Keyboard Shortcuts

| Platform   | Shortcut                    |
| ---------- | --------------------------- |
| macOS      | `Ctrl + Cmd + Delete`       |
| Windows    | `Ctrl + Win + Backspace`    |
| Linux      | `Ctrl + Meta + Backspace`   |
| Chromebook | `Ctrl + Search + Backspace` |

The Search key on Chromebook (where Caps Lock usually is) maps to `meta`. On macOS, `cmd` is used since there's no `meta` key.

---

## Tech Stack

This extension has two separate codebases that communicate via message passing:

```
┌─────────────────────────────────────────────────────────────────┐
│                         VS Code                                  │
│  ┌─────────────────────┐       ┌─────────────────────────────┐  │
│  │   Extension Host    │       │         Webview             │  │
│  │   (Node.js)         │       │         (Browser)           │  │
│  │                     │       │                             │  │
│  │  src/extension.ts   │──────▶│  webview/src/App.svelte    │  │
│  │  - TypeScript       │ post  │  - Svelte 5                │  │
│  │  - VS Code API      │ Msg   │  - Vite bundler            │  │
│  │  - Compiled by tsc  │       │  - CSS variables           │  │
│  └─────────────────────┘       └─────────────────────────────┘  │
│           │                                │                     │
│           ▼                                ▼                     │
│       out/extension.js               dist/webview.js             │
└─────────────────────────────────────────────────────────────────┘
```

### Component Relationships

| Component                | Role                                                                 | Build Tool         | Output                 |
| ------------------------ | -------------------------------------------------------------------- | ------------------ | ---------------------- |
| **Extension** (`src/`)   | Registers commands, creates webview panels, listens to editor events | `tsc` (TypeScript) | `out/extension.js`     |
| **Webview** (`webview/`) | Renders UI, displays file contents, calculates stats                 | Vite + Svelte      | `dist/webview.js`      |
| **Turbo**                | Caches builds across the monorepo                                    | turborepo          | ~10x faster rebuilds   |
| **vsce**                 | Packages everything into `.vsix`                                     | @vscode/vsce       | `idiogloss-0.0.1.vsix` |

### Data Flow

1. User clicks icon → Extension creates/reveals global webview panel
2. Extension reads active editor content → sends `postMessage` to webview
3. User switches files → `onDidChangeActiveTextEditor` fires → Extension sends new file content
4. User edits file → `onDidChangeTextDocument` fires → Extension sends updated content
5. Webview receives message → Svelte reactivity updates UI

---

## Project Structure

```
idiogloss/
├── src/
│   └── extension.ts        # Extension entry point (Node.js)
├── webview/
│   ├── src/
│   │   ├── App.svelte      # UI component (Svelte 5)
│   │   └── main.ts         # Webview entry point
│   ├── index.html          # Dev server HTML (not packaged)
│   ├── vite.config.ts      # Vite build configuration
│   └── svelte.config.mjs   # Svelte preprocessor config
├── dist/                   # Compiled webview (git-ignored)
│   ├── webview.js          # Bundled Svelte app
│   └── webview.css         # Extracted styles
├── out/                    # Compiled extension (git-ignored)
│   └── extension.js        # Compiled TypeScript
├── media/
│   ├── icon-dark.svg       # Source icon (editable)
│   ├── icon-light.svg      # Source icon (editable)
│   ├── icon-dark.png       # Compiled icon for dark themes
│   └── icon-light.png      # Compiled icon for light themes
├── package.json            # Extension manifest + npm scripts
├── tsconfig.json           # TypeScript config for extension
├── .vscodeignore           # Files excluded from .vsix
├── .npmrc                  # pnpm configuration
└── .gitignore              # Git ignores
```

---

## Deep Dive: Implementation Details

### Extension Entry Point (`src/extension.ts`)

The extension runs in VS Code's Extension Host (Node.js process, separate from the UI).

```typescript
// Global panel instance (singleton)
let globalPanel: vscode.WebviewPanel | undefined;

export function activate(context: vscode.ExtensionContext) {
  const openPanelCmd = vscode.commands.registerCommand("idiogloss.openPanel", () => {
    // If panel already exists, reveal it and update
    if (globalPanel) {
      globalPanel.reveal(vscode.ViewColumn.Beside);
      sendUpdate();
      return;
    }

    // Create global webview panel
    globalPanel = vscode.window.createWebviewPanel(
      "idiogloss",                    // Panel type ID
      "idiogloss",                    // Panel title (not file-specific)
      vscode.ViewColumn.Beside,       // Open beside current editor
      { enableScripts: true, ... }    // Options
    );

    // Listen for active editor changes
    vscode.window.onDidChangeActiveTextEditor((editor) => {
      if (editor) sendUpdate();
    });

    // Listen for document content changes
    vscode.workspace.onDidChangeTextDocument((e) => {
      if (e.document === vscode.window.activeTextEditor?.document) {
        sendUpdate();
      }
    });
  });
}
```

**Key APIs used:**

- `vscode.commands.registerCommand` — Register the command
- `vscode.window.createWebviewPanel` — Create the panel
- `panel.webview.postMessage` — Send data to webview
- `vscode.window.onDidChangeActiveTextEditor` — Track file switches
- `vscode.workspace.onDidChangeTextDocument` — Listen for edits

### Webview Panel Options

```typescript
{
  enableScripts: true,           // Allow JavaScript in webview
  retainContextWhenHidden: true, // Keep state when panel hidden
  localResourceRoots: [          // Security: limit file access
    vscode.Uri.joinPath(context.extensionUri, "dist"),
  ],
}
```

**Why `retainContextWhenHidden: true`?**

Without this, VS Code destroys the webview's JavaScript context when the panel is hidden (e.g., switching tabs, toggling terminal). When shown again, it recreates from scratch — losing all state.

With this option, the webview stays in memory. The Svelte app keeps its state (file contents, calculated stats).

**Trade-off:** Uses more memory. Acceptable for simple webviews like this.

### Global Panel: Active Editor Tracking

The panel is a singleton that tracks whatever editor is currently active:

```typescript
// Listen for active editor changes
const editorChangeListener = vscode.window.onDidChangeActiveTextEditor(
  (editor) => {
    if (editor) {
      sendUpdate(); // Send new file's content to webview
    }
  },
);

// Listen for document content changes
const contentChangeListener = vscode.workspace.onDidChangeTextDocument((e) => {
  const activeDoc = vscode.window.activeTextEditor?.document;
  if (activeDoc && e.document.uri.toString() === activeDoc.uri.toString()) {
    sendUpdate();
  }
});

panel.onDidDispose(() => {
  editorChangeListener.dispose();
  contentChangeListener.dispose();
  globalPanel = undefined; // Clear singleton reference
});
```

This sends the full document content on every keystroke and file switch. For large files, this could be optimized to send only changed ranges — but for typical use, full content is fast enough.

### Webview HTML Generation

The extension generates HTML that loads the compiled Svelte bundle:

```typescript
function getWebviewContent(webview, extensionUri) {
  const scriptUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, "dist", "webview.js"),
  );
  const styleUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, "dist", "webview.css"),
  );

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="stylesheet" href="${styleUri}">
</head>
<body>
  <div id="app"></div>
  <script type="module" src="${scriptUri}"></script>
</body>
</html>`;
}
```

**Why `asWebviewUri`?** Webviews run in an isolated context with a special `vscode-webview://` protocol. This method converts file paths to URIs the webview can access.

### Svelte 5 Reactive State (`webview/src/App.svelte`)

```svelte
<script lang="ts">
  let fileName = $state("");
  let content = $state("");
  let lineCount = $derived(content.split("\n").length);
  let charCount = $derived(content.length);
  let wordCount = $derived(content.trim() ? content.trim().split(/\s+/).length : 0);

  window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.type === "update") {
      fileName = message.fileName;
      content = message.content;
    }
  });
</script>
```

**Svelte 5 Runes:**

- `$state()` — Reactive variable (replaces `let x = ...` from Svelte 4)
- `$derived()` — Computed value that auto-updates when dependencies change

When `content` changes, `lineCount`, `charCount`, and `wordCount` automatically recalculate.

### VS Code Theme Integration

The webview CSS uses VS Code's CSS custom properties for theme matching:

```css
main {
  font-family: var(--vscode-font-family);
  color: var(--vscode-foreground);
  background-color: var(--vscode-editor-background);
}

pre {
  background-color: var(--vscode-textBlockQuote-background);
}

code {
  font-family: var(--vscode-editor-font-family), monospace;
  font-size: var(--vscode-editor-font-size);
}
```

VS Code injects these variables into webviews automatically. The panel adapts to light/dark themes without extra code.

### Vite Configuration (`webview/vite.config.ts`)

```typescript
export default defineConfig({
  plugins: [svelte()],
  build: {
    outDir: "../dist", // Output to extension's dist/
    emptyOutDir: true, // Clean before build
    rollupOptions: {
      output: {
        entryFileNames: "webview.js", // Predictable filename
        assetFileNames: "webview.[ext]", // webview.css
      },
    },
  },
});
```

**Why predictable filenames?** The extension hardcodes `dist/webview.js` and `dist/webview.css`. Without this config, Vite would generate hashed names like `webview-abc123.js`.

### Svelte Config (`webview/svelte.config.mjs`)

```javascript
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

export default {
  preprocess: vitePreprocess(),
};
```

Enables `<script lang="ts">` in Svelte files. The `.mjs` extension avoids "module type" warnings in a CommonJS project.

### TypeScript Configuration (`tsconfig.json`)

```json
{
  "compilerOptions": {
    "module": "commonjs", // VS Code extensions use CommonJS
    "target": "ES2020", // Modern JavaScript features
    "outDir": "out", // Compile to out/
    "rootDir": "src", // Only compile src/
    "strict": true, // Type safety
    "esModuleInterop": true, // Import compatibility
    "skipLibCheck": true // Faster compilation
  }
}
```

**Why CommonJS?** VS Code's extension host expects CommonJS modules (`require`/`module.exports`), not ES modules.

---

## Deep Dive: Package Configuration

### package.json Manifest

```json
{
  "name": "idiogloss",
  "engines": { "vscode": "^1.107.0" },
  "main": "./out/extension.js",
  "activationEvents": ["onStartupFinished"],
  "contributes": {
    "commands": [...],
    "menus": {...},
    "keybindings": [...]
  }
}
```

**`engines.vscode: "^1.107.0"`** — Minimum VS Code version. Set to 1.107.0 for code-server compatibility.

**`activationEvents: ["onStartupFinished"]`** — Extension loads after VS Code fully starts (lazy loading). Could be more specific (e.g., `onCommand:idiogloss.openPanel`) but startup-finished is simpler.

### Command Registration

```json
"contributes": {
  "commands": [{
    "command": "idiogloss.openPanel",
    "title": "idiogloss: Open Panel",
    "icon": {
      "light": "media/icon-light.png",
      "dark": "media/icon-dark.png"
    }
  }]
}
```

VS Code automatically picks light/dark icon based on theme.

### Menu Placement

```json
"menus": {
  "editor/title": [{
    "command": "idiogloss.openPanel",
    "group": "navigation",
    "when": "editorFocus"
  }]
}
```

Places the icon in the editor title bar. `group: "navigation"` puts it with other nav icons. `when: "editorFocus"` shows it only when an editor is focused.

### Keybindings

```json
"keybindings": [{
  "command": "idiogloss.openPanel",
  "key": "ctrl+meta+backspace",
  "mac": "ctrl+cmd+backspace",
  "when": "editorFocus"
}]
```

**Platform handling:** `key` is the default; `mac` overrides for macOS. On macOS, there's no `meta` key, so `cmd` is used. The `ctrl` modifier is added to avoid conflicts with system shortcuts.

### Icons: PNG vs SVG

VS Code forces SVG colors to match the theme in the editor title bar. To preserve our custom pink pig snout, we use PNG icons instead.

**Workflow:**

1. Edit SVG source files in `media/`
2. Convert to PNG:
   ```bash
   cd media
   convert -background none icon-dark.svg icon-dark.png
   convert -background none icon-light.svg icon-light.png
   ```
3. Rebuild extension

### .vscodeignore

```
.gitignore
src/
tsconfig.json
node_modules/
pnpm-lock.yaml
**/*.svg
webview/
.turbo/
```

Excludes development files from the packaged `.vsix`. Only includes:

- `out/` — Compiled extension
- `dist/` — Compiled webview
- `media/*.png` — Icons
- `package.json` — Manifest
- `README.md` — Shown in marketplace

### .npmrc

```
ignore-scripts=true
loglevel=error
```

- `ignore-scripts=true` — Suppresses warnings about missing build scripts during `pnpm install`
- `loglevel=error` — Reduces noise from deprecated dependency warnings

---

## Deep Dive: Build System

### Build Scripts

```json
"scripts": {
  "compile": "tsc",
  "compile:webview": "vite build webview",
  "build": "pnpm compile && pnpm compile:webview",
  "watch": "tsc -w",
  "package": "vsce package --no-dependencies --allow-missing-repository",
  "use": "turbo run build --filter=idiogloss && pnpm package && code --install-extension idiogloss-*.vsix"
}
```

| Script            | What it does                                   |
| ----------------- | ---------------------------------------------- |
| `compile`         | Compiles `src/` TypeScript → `out/` JavaScript |
| `compile:webview` | Builds Svelte app → `dist/`                    |
| `build`           | Runs both compiles                             |
| `watch`           | Auto-recompile extension on changes            |
| `package`         | Creates `.vsix` installer package              |
| `use`             | Full pipeline: build → package → install       |

### Turbo Integration

In the monorepo's `turbo.json`:

```json
{
  "idiogloss#build": {
    "outputs": ["out/**", "dist/**"],
    "inputs": ["src/**", "webview/**", "package.json", "tsconfig.json"]
  }
}
```

Turbo caches build outputs. If inputs haven't changed, it replays cached output (~10x faster).

**Why filter?** `--filter=idiogloss` ensures only this package builds, not the entire monorepo.

### vsce Flags

```bash
vsce package --no-dependencies --allow-missing-repository
```

- `--no-dependencies` — Don't bundle `node_modules` (extension has no runtime deps)
- `--allow-missing-repository` — Skip repo field validation in package.json

---

## Debugging

### View Extension Logs

1. Open Output panel (View → Output, or `Ctrl+Shift+U`)
2. Select "idiogloss" from the dropdown

Logs include timestamps:

```
[2025-01-11T02:00:00.000Z] Extension activating...
[2025-01-11T02:00:00.001Z] Extension activated
[2025-01-11T02:00:05.000Z] Creating panel for: example.ts
[2025-01-11T02:00:05.001Z] Panel created: example.ts
```

The Output panel does NOT auto-show. This is intentional — auto-showing panels disrupts workflow.

### Debug Webview

Open DevTools for the webview:

- macOS: `Opt + Cmd + I`
- Other: `Ctrl + Shift + I`

Or: Command Palette → "Developer: Open Webview Developer Tools"

---

## Publishing

To publish to the VS Code Marketplace:

1. Create a publisher at https://marketplace.visualstudio.com/manage
2. Get a Personal Access Token from https://dev.azure.com
3. Login: `pnpm vsce login <publisher>`
4. Publish: `pnpm vsce publish`
