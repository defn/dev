<!--
  Main idiogloss Android app component.

  Flow:
  1. On mount, check for stored config
  2. If no config, show QR scanner
  3. If config exists, show main UI with server connection

  Uses Svelte 5 runes for state management.
-->
<script lang="ts">
  import { onMount } from "svelte";
  import Scanner from "./lib/Scanner.svelte";
  import {
    loadConfig,
    saveConfig,
    clearConfig,
    type IdioglossConfig,
  } from "./lib/config";

  // App state
  let loading = $state(true);
  let config = $state<IdioglossConfig | null>(null);

  onMount(async () => {
    config = await loadConfig();
    loading = false;
  });

  async function handleScan(newConfig: IdioglossConfig) {
    await saveConfig(newConfig);
    config = newConfig;
  }

  async function handleReset() {
    await clearConfig();
    config = null;
  }
</script>

{#if loading}
  <!-- Loading state -->
  <div class="flex items-center justify-center min-h-screen">
    <div class="text-abyss-400">Loading...</div>
  </div>
{:else if !config}
  <!-- No config - show scanner -->
  <Scanner onScan={handleScan} />
{:else}
  <!-- Main UI -->
  <div class="flex flex-col min-h-screen">
    <!-- Header -->
    <header class="bg-abyss-900 border-b border-abyss-700 p-4">
      <div class="flex items-center justify-between">
        <h1 class="font-hellsing text-xl text-blood-500">idiogloss</h1>
        <button
          onclick={handleReset}
          class="text-abyss-400 hover:text-abyss-200 text-sm"
        >
          Reset
        </button>
      </div>
    </header>

    <!-- Main content -->
    <main class="flex-1 p-4">
      <div class="bg-abyss-900 rounded-lg p-4 border border-abyss-700">
        <h2 class="text-abyss-200 font-semibold mb-2">Connected</h2>
        <p class="text-abyss-400 text-sm font-mono break-all">
          {config.server}
        </p>
        {#if config.name}
          <p class="text-abyss-500 text-xs mt-2">
            Device: {config.name}
          </p>
        {/if}
      </div>

      <!-- Placeholder for future features -->
      <div class="mt-4 text-center text-abyss-500 text-sm">
        Agent communication coming soon...
      </div>
    </main>

    <!-- Footer -->
    <footer class="bg-abyss-900 border-t border-abyss-700 p-4">
      <p class="text-abyss-500 text-xs text-center">
        Secure mobile companion
      </p>
    </footer>
  </div>
{/if}
