# idiogloss

Secure mobile companion for the idiogloss VS Code extension.

## Stack

- **Svelte 5** - UI framework with runes
- **Vite** - Build tool
- **Tailwind CSS v4** - Styling with Hellsing theme
- **Capacitor** - Native Android shell with Chrome WebView
- **ML Kit** - QR code scanning

## Setup

```bash
pnpm install
pnpm cap add android
```

## Development

```bash
# Build and sync to Android
pnpm sync

# Open in Android Studio
pnpm android

# Build, sync, and run on device
pnpm use
```

## Configuration

On first launch, the app prompts for a QR code containing JSON config:

```json
{
  "server": "http://100.x.x.x:8080",
  "name": "my-phone"
}
```

Generate QR codes at [qr.io](https://qr.io) or similar.

## Publishing

1. Update version in `package.json`
2. Build release: `pnpm build`
3. Open Android Studio: `pnpm android`
4. Build > Generate Signed Bundle / APK
