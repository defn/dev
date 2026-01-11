# idiogloss - VS Code Extension

AI-powered code assistant that displays file contents and statistics in a dedicated webview panel.

## Architecture

Three-layer architecture communicating via message passing:

```
┌─────────────────────────────────────────────────────────────────────┐
│                           VS Code                                    │
│  ┌──────────────────────┐         ┌─────────────────────────────┐   │
│  │   Extension Host     │         │         Webview             │   │
│  │   (Node.js)          │         │         (Browser)           │   │
│  │                      │ postMsg │                             │   │
│  │   src/extension.ts   │────────>│   webview/src/App.svelte    │   │
│  │                      │         │                             │   │
│  └──────────┬───────────┘         └─────────────────────────────┘   │
│             │                                                        │
│             │ Unix Socket (JSON-RPC)                                 │
│             │ /tmp/idiogloss-agent.sock                              │
│             ▼                                                        │
│  ┌──────────────────────┐                                           │
│  │   Agent Server       │                                           │
│  │   (Python)           │                                           │
│  │   //agents/idiogloss │                                           │
│  └──────────────────────┘                                           │
└─────────────────────────────────────────────────────────────────────┘
```

## Key Entry Points

| File                     | Purpose                                                             |
| ------------------------ | ------------------------------------------------------------------- |
| `src/extension.ts`       | Extension lifecycle (`activate`/`deactivate`), command registration |
| `src/panels/base.ts`     | Abstract `BasePanel` class - shared panel logic                     |
| `src/panels/global.ts`   | `GlobalPanel` - singleton tracking active editor                    |
| `src/panels/editor.ts`   | `EditorPanel` - per-file panel instance                             |
| `src/agent/client.ts`    | `AgentClient` - Unix socket IPC to Python agent                     |
| `src/agent/types.ts`     | TypeScript interfaces for agent communication                       |
| `webview/src/App.svelte` | Svelte 5 UI component                                               |
| `webview/src/main.ts`    | Webview entry point                                                 |

## Module Map

```
src/
├── extension.ts          # Main entry - activate(), deactivate()
├── panels/
│   ├── index.ts          # Barrel exports
│   ├── base.ts           # BasePanel abstract class
│   ├── global.ts         # GlobalPanel (singleton, tracks active editor)
│   └── editor.ts         # EditorPanel (one per file)
├── agent/
│   ├── index.ts          # Barrel exports
│   ├── client.ts         # AgentClient class (socket communication)
│   ├── types.ts          # AgentRequest, AgentResponse interfaces
│   └── utils.ts          # truncateContent() helper
└── utils/
    ├── index.ts          # Barrel exports
    ├── logger.ts         # log() function, VS Code output channel
    └── activeEditor.ts   # getActiveEditorInfo(), getDocumentInfo()

webview/
├── src/
│   ├── main.ts           # Mounts Svelte app to #app
│   └── App.svelte        # UI with reactive state ($state, $derived)
├── vite.config.ts        # Vite build config
└── svelte.config.mjs     # Svelte preprocessor config
```

## Communication Protocols

### Extension <-> Webview (postMessage)

```typescript
// Extension sends to webview
interface PanelMessage {
  type: "update" | "stats" | "serverInfo" | "serverStatus";
  fileName?: string;
  content?: string;
  stats?: ContentStats;
  connected?: boolean;
}
```

### Extension <-> Agent (Unix Socket JSON-RPC)

```typescript
// Extension sends to agent
interface AgentRequest {
  action: "ping" | "query" | "shutdown" | "stats";
  prompt?: string;
  content?: string;
  file_name?: string;
}

// Agent responds
interface AgentResponse {
  success: boolean;
  response?: string;
  error?: string;
  stats?: ContentStats;
  pong?: boolean;
}
```

## Commands

| Command                     | Description                              |
| --------------------------- | ---------------------------------------- |
| `idiogloss.openPanel`       | Open global panel (tracks active editor) |
| `idiogloss.openEditorPanel` | Open panel for current file only         |
| `idiogloss.startAgent`      | Manually start agent server              |
| `idiogloss.stopAgent`       | Stop agent server                        |
| `idiogloss.queryAgent`      | Send prompt to agent                     |

## Build

```bash
pnpm build          # Compile extension + webview
pnpm use            # Build, package, and install to VS Code
```

Outputs:

- `out/extension.js` - Compiled extension (tsc)
- `dist/webview.js` - Bundled Svelte app (Vite)

## Debugging

- **Extension logs**: View -> Output -> "idiogloss"
- **Log file**: `/tmp/idiogloss-extension.log`
- **Webview DevTools**: Cmd+Opt+I (Mac) or Ctrl+Shift+I
