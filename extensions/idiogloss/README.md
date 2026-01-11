# Idiogloss

A VS Code extension that opens a webview panel paired to your current editor.

## Usage

1. Open any file in the editor
2. Open the Idiogloss panel using either:
   - Click the pig snout icon in the editor title bar (top right, near split/more buttons)
   - Keyboard shortcut (see below)
3. A panel opens beside your editor showing the file contents

### Keyboard Shortcuts

| Platform | Shortcut |
|----------|----------|
| macOS | `Cmd + Delete` |
| Chromebook | `Search + Backspace` |
| Windows | `Win + Backspace` |
| Linux | `Meta + Backspace` |

The Search key on Chromebook (where Caps Lock usually is) maps to `meta`. On macOS, `cmd` is used instead since there's no `meta` key.

## Development

### Prerequisites

- Node.js
- pnpm
- ImageMagick (for icon conversion)

### Project Structure

```
idiogloss/
├── src/
│   └── extension.ts      # Main extension code
├── media/
│   ├── icon-dark.svg     # Source icon for dark themes
│   ├── icon-light.svg    # Source icon for light themes
│   ├── icon-dark.png     # Compiled icon (used by VS Code)
│   └── icon-light.png    # Compiled icon (used by VS Code)
├── out/                   # Compiled JavaScript (git-ignored)
├── package.json           # Extension manifest
├── tsconfig.json          # TypeScript config
├── .vscodeignore          # Files to exclude from .vsix package
└── .npmrc                 # pnpm config
```

### Key Files Explained

- **package.json**: Defines the extension metadata, commands, menus, icons, and keybindings. The `contributes` section registers:
  - `commands`: The "Open Panel" command with its icon
  - `menus.editor/title`: Places the icon in the editor title bar
  - `keybindings`: Keyboard shortcuts (uses `key` for default, `mac` for macOS override)

- **src/extension.ts**: The main code that:
  - Registers the command handler
  - Creates a webview panel when the icon is clicked
  - Passes the current filename to the webview

- **media/\*.svg**: Source icons (not packaged). Edit these to change the icon appearance.
- **media/\*.png**: Compiled icons that VS Code actually uses. VS Code forces colors on SVG icons in the editor title bar, so we use PNGs to preserve colors.

### Commands

```bash
# Install dependencies
pnpm install

# Compile TypeScript
pnpm compile

# Watch mode (auto-recompile on changes)
pnpm watch

# Package as .vsix
pnpm package

# Build, package, and install in one step
pnpm use
```

### Development Workflow

1. Edit `src/extension.ts`
2. Run `pnpm use` to compile and install
3. Reload VS Code window (Ctrl+Shift+P → "Developer: Reload Window")
4. Test your changes

### Updating Icons

1. Edit the SVG source files in `media/`
2. Convert to PNG:
   ```bash
   cd media
   convert -background none icon-dark.svg icon-dark.png
   convert -background none icon-light.svg icon-light.png
   ```
3. Run `pnpm use` to rebuild

### Why PNG Instead of SVG?

VS Code overrides SVG colors in the editor title bar to match the theme. To preserve our custom pink pig snout colors, we use PNG icons instead. The SVGs are kept as editable source files but excluded from the final package via `.vscodeignore`.

### Light vs Dark Icons

VS Code automatically picks the right icon based on theme:

- `icon-dark.png`: Shown in dark themes (lighter pink)
- `icon-light.png`: Shown in light themes (darker pink for contrast)

This is configured in `package.json`:

```json
"icon": {
  "light": "media/icon-light.png",
  "dark": "media/icon-dark.png"
}
```

## Publishing

To publish to the VS Code Marketplace:

1. Create a publisher at https://marketplace.visualstudio.com/manage
2. Get a Personal Access Token from https://dev.azure.com
3. Login: `pnpm vsce login <publisher>`
4. Publish: `pnpm vsce publish`
