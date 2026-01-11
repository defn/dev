<script lang="ts">
  let fileName = $state("");
  let content = $state("");
  let lineCount = $derived(content.split("\n").length);
  let charCount = $derived(content.length);
  let wordCount = $derived(content.trim() ? content.trim().split(/\s+/).length : 0);

  // Listen for messages from the extension
  window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.type === "update") {
      fileName = message.fileName;
      content = message.content;
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
