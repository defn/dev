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

## Building from Linux k8s Pod

No Android Studio required. Build APKs with Gradle directly.

### Dockerfile with Android SDK

```dockerfile
FROM gradle:8-jdk17

# Android SDK command-line tools
RUN apt-get update && apt-get install -y wget unzip
RUN mkdir -p /opt/android-sdk/cmdline-tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/tools.zip
RUN unzip -q /tmp/tools.zip -d /opt/android-sdk/cmdline-tools \
    && mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

RUN yes | sdkmanager --licenses
RUN sdkmanager "platforms;android-34" "build-tools;34.0.0"
```

### Build APK

```bash
cd android && ./gradlew assembleDebug
# Output: android/app/build/outputs/apk/debug/app-debug.apk
```

### Distribute to Device

| Method | Command |
|--------|---------|
| **HTTP + Tailscale** | `python3 -m http.server 8080 -d app/build/outputs/apk/debug/` |
| **Firebase** | `firebase appdistribution:distribute app-debug.apk` |
| **ADB (wired)** | `adb install app-debug.apk` |

For HTTP method, navigate to `http://100.x.x.x:8080/app-debug.apk` on your phone to download and install.
