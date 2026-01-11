/**
 * Configuration storage for idiogloss Android app.
 *
 * Uses Capacitor Preferences API for persistent JSON config storage.
 * Config is obtained via QR code scanning on first launch.
 *
 * Expected config structure (scanned from QR):
 * {
 *   "server": "http://100.x.x.x:8080",  // Tailscale IP for agent server
 *   "name": "device-name"                // Optional device identifier
 * }
 */

import { Preferences } from "@capacitor/preferences";

const CONFIG_KEY = "idiogloss_config";

export interface IdioglossConfig {
  server: string;
  name?: string;
}

/**
 * Load config from persistent storage.
 * Returns null if no config exists (triggers QR scanner).
 */
export async function loadConfig(): Promise<IdioglossConfig | null> {
  const { value } = await Preferences.get({ key: CONFIG_KEY });
  if (!value) return null;

  try {
    return JSON.parse(value) as IdioglossConfig;
  } catch {
    // Corrupted config, clear and return null
    await clearConfig();
    return null;
  }
}

/**
 * Save config to persistent storage.
 * Called after successful QR scan.
 */
export async function saveConfig(config: IdioglossConfig): Promise<void> {
  await Preferences.set({
    key: CONFIG_KEY,
    value: JSON.stringify(config),
  });
}

/**
 * Clear stored config.
 * Useful for resetting the app or switching servers.
 */
export async function clearConfig(): Promise<void> {
  await Preferences.remove({ key: CONFIG_KEY });
}

/**
 * Parse QR code content into config.
 * Validates required fields before returning.
 */
export function parseQrConfig(content: string): IdioglossConfig | null {
  try {
    const parsed = JSON.parse(content);
    if (typeof parsed.server !== "string" || !parsed.server) {
      return null;
    }
    return {
      server: parsed.server,
      name: parsed.name,
    };
  } catch {
    return null;
  }
}
