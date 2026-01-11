import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  console.log("Idiogloss extension is now active");

  const openPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openPanel",
    () => {
      const editor = vscode.window.activeTextEditor;
      const fileName = editor?.document.fileName.split("/").pop() ?? "Unknown";
      const content = editor?.document.getText() ?? "";

      const panel = vscode.window.createWebviewPanel(
        "idiogloss",
        `Idiogloss: ${fileName}`,
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
        },
      );

      panel.webview.html = getWebviewContent(fileName, content);
    },
  );

  context.subscriptions.push(openPanelCmd);
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

export function deactivate() {}
