import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "com.defn.idiogloss",
  appName: "idiogloss",
  webDir: "dist",
  server: {
    // For development, allow cleartext traffic to Tailscale IPs
    cleartext: true,
  },
  android: {
    // Use Chrome WebView
    webContentsDebuggingEnabled: true,
  },
};

export default config;
