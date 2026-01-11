<script lang="ts">
  let fileName = $state("");
  let content = $state("");
  let lineCount = $state(0);
  let wordCount = $state(0);
  let charCount = $state(0);
  let serverConnected = $state(false);
  let serverStartTime = $state(0);
  let serverPid = $state(0);
  let uptimeSeconds = $state(0);

  // Update uptime every second
  setInterval(() => {
    if (serverStartTime > 0) {
      uptimeSeconds = Math.floor(Date.now() / 1000 - serverStartTime);
    }
  }, 1000);

  function formatUptime(seconds: number): string {
    if (seconds < 60) return `${seconds}s`;
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    if (mins < 60) return `${mins}m ${secs}s`;
    const hours = Math.floor(mins / 60);
    const remainingMins = mins % 60;
    return `${hours}h ${remainingMins}m`;
  }

  // Listen for messages from the extension
  window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.type === "update") {
      fileName = message.fileName;
      content = message.content;
      // Fallback to local calculation if no stats from server
      if (!message.stats) {
        lineCount = content.split("\n").length;
        wordCount = content.trim() ? content.trim().split(/\s+/).length : 0;
        charCount = content.length;
      }
    } else if (message.type === "stats") {
      serverConnected = true;
      if (message.stats) {
        lineCount = message.stats.lines;
        wordCount = message.stats.words;
        charCount = message.stats.characters;
      }
    } else if (message.type === "serverInfo") {
      serverConnected = true;
      serverStartTime = message.server_start_time || 0;
      serverPid = message.server_pid || 0;
      uptimeSeconds = Math.floor(Date.now() / 1000 - serverStartTime);
    } else if (message.type === "serverStatus") {
      serverConnected = message.connected;
      if (!message.connected) {
        serverStartTime = 0;
        serverPid = 0;
        uptimeSeconds = 0;
      }
    }
  });
</script>

<main>
  <h1>{fileName || "Unknown"}</h1>

  <div class="stats">
    <span class="stat">
      <strong>{lineCount}</strong> lines
    </span>
    <span class="stat">
      <strong>{wordCount}</strong> words
    </span>
    <span class="stat">
      <strong>{charCount}</strong> chars
    </span>
    <span class="status" class:connected={serverConnected}>
      {#if serverConnected}
        server (pid:{serverPid}, up:{formatUptime(uptimeSeconds)})
      {:else}
        local
      {/if}
    </span>
  </div>

  <pre><code>{content}</code></pre>
</main>

<style>
  main {
    font-family: var(--vscode-font-family);
    padding: 20px;
    color: var(--vscode-foreground);
    background-color: var(--vscode-editor-background);
  }

  h1 {
    border-bottom: 1px solid var(--vscode-panel-border);
    padding-bottom: 10px;
    margin-bottom: 10px;
  }

  .stats {
    display: flex;
    gap: 16px;
    margin-bottom: 16px;
    font-size: 0.9em;
    color: var(--vscode-descriptionForeground);
  }

  .stat strong {
    color: var(--vscode-foreground);
  }

  .status {
    margin-left: auto;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 0.8em;
    background-color: var(--vscode-badge-background);
    color: var(--vscode-badge-foreground);
  }

  .status.connected {
    background-color: var(--vscode-testing-iconPassed);
    color: var(--vscode-editor-background);
  }

  pre {
    background-color: var(--vscode-textBlockQuote-background);
    padding: 16px;
    overflow: auto;
    border-radius: 4px;
  }

  code {
    font-family: var(--vscode-editor-font-family), monospace;
    font-size: var(--vscode-editor-font-size);
  }
</style>
