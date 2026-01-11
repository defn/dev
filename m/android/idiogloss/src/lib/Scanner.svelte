<!--
  QR Code Scanner component for idiogloss config.

  Uses ML Kit barcode scanning via Capacitor plugin.
  Requests camera permission on mount, scans for QR codes,
  and emits parsed config on successful scan.
-->
<script lang="ts">
  import {
    BarcodeScanner,
    BarcodeFormat,
  } from "@capacitor-mlkit/barcode-scanning";
  import { parseQrConfig, type IdioglossConfig } from "./config";

  interface Props {
    onScan: (config: IdioglossConfig) => void;
  }

  let { onScan }: Props = $props();

  let scanning = $state(false);
  let error = $state<string | null>(null);

  async function startScan() {
    error = null;
    scanning = true;

    try {
      // Check/request camera permission
      const { camera } = await BarcodeScanner.checkPermissions();
      if (camera !== "granted") {
        const result = await BarcodeScanner.requestPermissions();
        if (result.camera !== "granted") {
          error = "Camera permission required for QR scanning";
          scanning = false;
          return;
        }
      }

      // Scan for QR codes
      const { barcodes } = await BarcodeScanner.scan({
        formats: [BarcodeFormat.QrCode],
      });

      if (barcodes.length > 0 && barcodes[0].rawValue) {
        const config = parseQrConfig(barcodes[0].rawValue);
        if (config) {
          onScan(config);
        } else {
          error = "Invalid config QR code. Expected JSON with 'server' field.";
        }
      }
    } catch (e) {
      error = e instanceof Error ? e.message : "Scan failed";
    } finally {
      scanning = false;
    }
  }
</script>

<div class="flex flex-col items-center justify-center min-h-screen p-8">
  <h1 class="font-hellsing text-3xl text-blood-500 mb-4">idiogloss</h1>
  <p class="text-abyss-300 mb-8 text-center">
    Scan a configuration QR code to connect to your agent server.
  </p>

  {#if error}
    <div class="bg-blood-900/50 border border-blood-700 rounded-lg p-4 mb-6 max-w-sm">
      <p class="text-blood-300 text-sm">{error}</p>
    </div>
  {/if}

  <button
    onclick={startScan}
    disabled={scanning}
    class="bg-blood-700 hover:bg-blood-600 disabled:bg-abyss-700
           text-white font-semibold py-3 px-8 rounded-lg
           transition-colors duration-200
           shadow-blood disabled:shadow-none"
  >
    {scanning ? "Scanning..." : "Scan QR Code"}
  </button>

  <p class="text-abyss-400 text-xs mt-8 text-center max-w-xs">
    The QR code should contain JSON with a "server" field pointing to your
    Tailscale agent server address.
  </p>
</div>
