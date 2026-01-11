import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  console.log("Idiogloss extension is now active");

  const openPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openPanel",
    () => {
      const editor = vscode.window.activeTextEditor;
      const fileName = editor?.document.fileName.split("/").pop() ?? "Unknown";

      const panel = vscode.window.createWebviewPanel(
        "idiogloss",
        `Idiogloss: ${fileName}`,
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
        }
      );

      panel.webview.html = getWebviewContent(fileName);
    }
  );

  context.subscriptions.push(openPanelCmd);
}

function getWebviewContent(fileName: string): string {
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
  </style>
</head>
<body>
  <h1>${fileName}</h1>
</body>
</html>`;
}

export function deactivate() {}
