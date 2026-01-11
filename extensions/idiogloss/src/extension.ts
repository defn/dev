import * as vscode from "vscode";

const outputChannel = vscode.window.createOutputChannel("idiogloss");

function log(message: string) {
  const timestamp = new Date().toISOString();
  outputChannel.appendLine(`[${timestamp}] ${message}`);
}

export function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(outputChannel);
  // Note: outputChannel.show() is intentionally NOT called here.
  // Auto-showing the Output panel is disruptive to the user's workflow.
  // Users can manually view logs via Output panel > "idiogloss" dropdown.
  log("Extension activating...");

  const openPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openPanel",
    () => {
      const editor = vscode.window.activeTextEditor;
      const fileName = editor?.document.fileName.split("/").pop() ?? "Unknown";
      const content = editor?.document.getText() ?? "";

      log(`Creating panel for: ${fileName}`);

      const panel = vscode.window.createWebviewPanel(
        "idiogloss",
        `idiogloss: ${fileName}`,
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
        },
      );

      log(`Panel created: ${fileName}`);

      panel.onDidChangeViewState((e) => {
        const state = e.webviewPanel.visible ? "visible" : "hidden";
        log(`Panel ${fileName} is now ${state}`);
      });

      panel.onDidDispose(() => {
        log(`Panel disposed: ${fileName}`);
      });

      panel.webview.html = getWebviewContent(fileName, content);
    },
  );

  context.subscriptions.push(openPanelCmd);

  log("Extension activated");
}

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function getWebviewContent(fileName: string, content: string): string {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: var(--vscode-font-family);
      padding: 20px;
      color: var(--vscode-foreground);
      background-color: var(--vscode-editor-background);
    }
    h1 {
      border-bottom: 1px solid var(--vscode-panel-border);
      padding-bottom: 10px;
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
</head>
<body>
  <h1>${escapeHtml(fileName)}</h1>
  <pre><code>${escapeHtml(content)}</code></pre>
</body>
</html>`;
}

export function deactivate() {
  log("Extension deactivated");
}
