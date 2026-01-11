import * as vscode from "vscode";

const outputChannel = vscode.window.createOutputChannel("idiogloss");

function log(message: string) {
  const timestamp = new Date().toISOString();
  outputChannel.appendLine(`[${timestamp}] ${message}`);
}

// Global panel instance (singleton)
let globalPanel: vscode.WebviewPanel | undefined;

export function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(outputChannel);
  // Note: outputChannel.show() is intentionally NOT called here.
  // Auto-showing the Output panel is disruptive to the user's workflow.
  // Users can manually view logs via Output panel > "idiogloss" dropdown.
  log("Extension activating...");

  // Helper to get current editor info
  function getEditorInfo() {
    const editor = vscode.window.activeTextEditor;
    const document = editor?.document;
    const fileName = document?.fileName.split("/").pop() ?? "No file";
    const content = document?.getText() ?? "";
    return { editor, document, fileName, content };
  }

  // Helper to send update to panel
  function sendUpdate() {
    if (!globalPanel) return;
    const { fileName, content } = getEditorInfo();
    globalPanel.webview.postMessage({
      type: "update",
      fileName,
      content,
    });
  }

  const openPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openPanel",
    () => {
      // If panel already exists, reveal it and update
      if (globalPanel) {
        globalPanel.reveal(vscode.ViewColumn.Beside);
        sendUpdate();
        log("Panel revealed");
        return;
      }

      const { fileName } = getEditorInfo();
      log(`Creating global panel`);

      globalPanel = vscode.window.createWebviewPanel(
        "idiogloss",
        "idiogloss",
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
          retainContextWhenHidden: true,
          localResourceRoots: [
            vscode.Uri.joinPath(context.extensionUri, "dist"),
          ],
        },
      );

      log(`Panel created`);

      // Listen for active editor changes
      const editorChangeListener = vscode.window.onDidChangeActiveTextEditor(
        (editor) => {
          if (editor) {
            const fileName =
              editor.document.fileName.split("/").pop() ?? "Unknown";
            log(`Active editor changed: ${fileName}`);
            sendUpdate();
          }
        },
      );

      // Listen for document content changes
      const contentChangeListener = vscode.workspace.onDidChangeTextDocument(
        (e) => {
          const activeDoc = vscode.window.activeTextEditor?.document;
          if (
            activeDoc &&
            e.document.uri.toString() === activeDoc.uri.toString()
          ) {
            sendUpdate();
          }
        },
      );

      globalPanel.onDidChangeViewState((e) => {
        const state = e.webviewPanel.visible ? "visible" : "hidden";
        log(`Panel is now ${state}`);
      });

      globalPanel.onDidDispose(() => {
        editorChangeListener.dispose();
        contentChangeListener.dispose();
        globalPanel = undefined;
        log(`Panel disposed`);
      });

      globalPanel.webview.html = getWebviewContent(
        globalPanel.webview,
        context.extensionUri,
      );

      // Send initial data
      sendUpdate();
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
