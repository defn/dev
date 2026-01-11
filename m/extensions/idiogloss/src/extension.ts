import * as vscode from "vscode";
import * as fs from "fs";
import * as path from "path";

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
      const document = editor?.document;
      const fileName = document?.fileName.split("/").pop() ?? "Unknown";
      const content = document?.getText() ?? "";

      log(`Creating panel for: ${fileName}`);

      const panel = vscode.window.createWebviewPanel(
        "idiogloss",
        `idiogloss: ${fileName}`,
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
          retainContextWhenHidden: true,
          localResourceRoots: [
            vscode.Uri.joinPath(context.extensionUri, "dist"),
          ],
        },
      );

      log(`Panel created: ${fileName}`);

      // Send updates when document changes
      const changeListener = vscode.workspace.onDidChangeTextDocument((e) => {
        if (document && e.document.uri.toString() === document.uri.toString()) {
          panel.webview.postMessage({
            type: "update",
            fileName,
            content: e.document.getText(),
          });
        }
      });

      panel.onDidChangeViewState((e) => {
        const state = e.webviewPanel.visible ? "visible" : "hidden";
        log(`Panel ${fileName} is now ${state}`);
      });

      panel.onDidDispose(() => {
        changeListener.dispose();
        log(`Panel disposed: ${fileName}`);
      });

      panel.webview.html = getWebviewContent(
        panel.webview,
        context.extensionUri,
      );

      // Send initial data to webview
      panel.webview.postMessage({
        type: "update",
        fileName,
        content,
      });
    },
  );

  context.subscriptions.push(openPanelCmd);

  log("Extension activated");
}

function getWebviewContent(
  webview: vscode.Webview,
  extensionUri: vscode.Uri,
): string {
  const scriptUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, "dist", "webview.js"),
  );
  const styleUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, "dist", "webview.css"),
  );

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${styleUri}">
</head>
<body>
  <div id="app"></div>
  <script type="module" src="${scriptUri}"></script>
</body>
</html>`;
}

export function deactivate() {
  log("Extension deactivated");
}
