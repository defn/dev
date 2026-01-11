# idiogloss

A VS Code extension with an AI-powered agent backend. Features a Hellsing-themed webview panel that tracks your current editor, showing file stats and Alucard's theatrical commentary.

## Quick Start

```bash
# Install dependencies
pnpm install

# Build and install the extension
pnpm use
```

Then reload VS Code (`Ctrl+Shift+P` → "Developer: Reload Window").

## Features

- **Global Panel** - Singleton panel that tracks active editor across all files
- **Editor Panel** - Per-file panel tied to specific editor instance
- **Agent Server** - Python backend using Claude Agent SDK with MCP tools
- **Live Stats** - Line, word, and character counts (server-computed)
- **Alucard Mode** - Theatrical vampire commentary on your code
- **Status Bar** - Shows agent server connection state
- **Heartbeat Monitor** - Auto-restarts server on failure with exponential backoff

## Commands

| Command                         | Description                                  |
| ------------------------------- | -------------------------------------------- |
| `idiogloss: Open Global Panel`  | Opens singleton panel tracking active editor |
| `idiogloss: Open Editor Panel`  | Opens panel for current file                 |
| `idiogloss: Start Agent Server` | Manually start the Python agent              |
| `idiogloss: Stop Agent Server`  | Stop the agent server                        |
| `idiogloss: Query Agent`        | Send a query to the agent                    |

## Keyboard Shortcuts

| Platform      | Global Panel          | Editor Panel     |
| ------------- | --------------------- | ---------------- |
| macOS         | `Ctrl+Cmd+Backspace`  | `Cmd+Backspace`  |
| Windows/Linux | `Ctrl+Meta+Backspace` | `Meta+Backspace` |

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              VS Code                                      │
│  ┌──────────────────────┐              ┌─────────────────────────────┐  │
│  │   Extension Host     │   postMsg    │         Webview             │  │
│  │   (TypeScript)       │─────────────▶│         (Svelte 5)          │  │
│  │                      │              │                             │  │
│  │  src/extension.ts    │              │  webview/src/App.svelte    │  │
│  │  src/agent/client.ts │              │  Hellsing/Alucard theme    │  │
│  │  src/panels/*.ts     │              │  Tailwind CSS              │  │
│  └──────────┬───────────┘              └─────────────────────────────┘  │
│             │ Unix Socket                                               │
│             │ /tmp/idiogloss.sock                                       │
│             ▼                                                           │
│  ┌──────────────────────┐                                               │
│  │   Agent Server       │                                               │
│  │   (Python)           │                                               │
│  │                      │                                               │
│  │  agents/idiogloss/   │                                               │
│  │  - Claude Agent SDK  │                                               │
│  │  - MCP Tools         │                                               │
│  └──────────────────────┘                                               │
└─────────────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
extensions/idiogloss/
├── src/
│   ├── extension.ts          # Entry point, commands, lifecycle
│   ├── agent/
│   │   ├── client.ts         # Unix socket client for Python agent
│   │   └── types.ts          # Request/response types
│   ├── panels/
│   │   ├── base.ts           # Abstract panel with shared logic
│   │   ├── global.ts         # Singleton panel tracking active editor
│   │   └── editor.ts         # Per-file panel
│   ├── utils/
│   │   ├── logger.ts         # Output channel logging
│   │   ├── timers.ts         # Debouncer, Heartbeat utilities
│   │   ├── notifications.ts  # Auto-dismissing notifications
│   │   └── activeEditor.ts   # Editor info helpers
│   └── webview/
│       └── content.ts        # HTML generation for webview
├── webview/
│   ├── src/
│   │   ├── App.svelte        # Main UI (Svelte 5, Hellsing theme)
│   │   └── main.ts           # Webview entry
│   └── vite.config.ts        # Vite build config
├── dist/                     # Compiled webview (git-ignored)
├── out/                      # Compiled extension (git-ignored)
└── package.json

agents/idiogloss/             # Python agent backend
├── server.py                 # Unix socket server
├── handlers.py               # Request dispatch and handlers
├── agent.py                  # Claude Agent SDK integration
└── stats.py                  # Content statistics
```

## Data Flow

1. **Startup** - Extension starts Python agent server via `bazel run`
2. **Connection** - Client connects to Unix socket at `/tmp/idiogloss.sock`
3. **Heartbeat** - Every 10s, pings server; restarts on failure (exponential backoff to 10min max)
4. **Content Updates** - Debounced (2s idle) before sending to server
5. **Stats Request** - Server computes line/word/char counts
6. **Alucard Request** - Agent uses Claude SDK + MCP tools to generate response
7. **Progress Streaming** - Tool calls and partial text streamed back during processing
8. **Webview Update** - Panel receives responses via postMessage

## Agent Features

The Python agent uses Claude Agent SDK with MCP tools:

- `get_time` - Current date/time
- `get_disk_usage` - Disk statistics
- `get_user_info` - User/group info

Alucard mode prompts Claude to respond as the vampire from Hellsing, incorporating tool results into theatrical monologues.

## Development

```bash
# Watch mode for extension TypeScript
pnpm watch

# Build everything
pnpm build

# Package as .vsix
pnpm package

# Build, package, and install
pnpm use
```

## Debugging

### Extension Logs

View → Output → Select "idiogloss" from dropdown

### Webview DevTools

- macOS: `Opt+Cmd+I`
- Windows/Linux: `Ctrl+Shift+I`

Or: Command Palette → "Developer: Open Webview Developer Tools"

### Agent Logs

Python agent logs to stdout/stderr, visible in the "idiogloss" output channel.

## Publishing

To publish to the VS Code Marketplace:

1. Create a publisher at https://marketplace.visualstudio.com/manage
2. Get a Personal Access Token from https://dev.azure.com (Scopes: Marketplace > Manage)
3. Login: `pnpm vsce login <publisher>`
4. Publish: `pnpm vsce publish`

Or publish manually:

```bash
pnpm package                    # Creates idiogloss-0.0.1.vsix
pnpm vsce publish --packagePath idiogloss-0.0.1.vsix
```
