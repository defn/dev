# idiogloss Webview

Svelte 5 UI for the idiogloss VS Code extension.

## Architecture

The webview runs in an isolated browser context within VS Code. It communicates with the extension host via `postMessage()`.

```
Extension Host                    Webview (Browser)
     │                                  │
     │   postMessage({ type, data })    │
     ├─────────────────────────────────>│
     │                                  │
     │   window.addEventListener        │
     │   ("message", handler)           │
     │                                  │
```

## Svelte 5 Runes

This project uses Svelte 5's new runes API for reactivity:

### `$state()` - Reactive Variables

```svelte
<script lang="ts">
  let fileName = $state("");
  let content = $state("");
</script>
```

Replaces Svelte 4's `let x = value` reactive declarations.

### `$derived()` - Computed Values

```svelte
<script lang="ts">
  let content = $state("");
  let lineCount = $derived(content.split("\n").length);
  let wordCount = $derived(content.trim() ? content.trim().split(/\s+/).length : 0);
</script>
```

Automatically recalculates when dependencies change. Replaces Svelte 4's `$:` reactive statements.

## Files

| File                | Purpose                                         |
| ------------------- | ----------------------------------------------- |
| `src/main.ts`       | Entry point - mounts Svelte app to `#app`       |
| `src/App.svelte`    | Main UI component with reactive state           |
| `vite.config.ts`    | Build configuration for Vite                    |
| `svelte.config.mjs` | Svelte preprocessor config (enables TypeScript) |
| `index.html`        | Dev server HTML (not packaged)                  |

## Message Types

The webview handles these message types from the extension:

| Type           | Fields                                         | Description                |
| -------------- | ---------------------------------------------- | -------------------------- |
| `update`       | `fileName`, `content`                          | File content changed       |
| `stats`        | `stats`                                        | Server-computed statistics |
| `serverInfo`   | `connected`, `server_start_time`, `server_pid` | Agent server info          |
| `serverStatus` | `connected`                                    | Connection status only     |

## Theme Integration

Uses VS Code CSS custom properties for automatic theme matching:

```css
color: var(--vscode-foreground);
background: var(--vscode-editor-background);
font-family: var(--vscode-editor-font-family);
```

## Development

```bash
# Build webview only
pnpm compile:webview

# Build with watch (extension only, not webview)
pnpm watch

# Full build
pnpm build
```

## Debugging

Open webview DevTools:

- macOS: `Opt + Cmd + I`
- Other: `Ctrl + Shift + I`
- Or: Command Palette -> "Developer: Open Webview Developer Tools"
