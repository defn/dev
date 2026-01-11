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
  log("Extension activating...");

  // Helper to get current editor info
  function getEditorInfo() {
    const editor = vscode.window.activeTextEditor;
    const document = editor?.document;
    const fileName = document?.fileName.split("/").pop() ?? "No file";
    const content = document?.getText() ?? "";
    return { editor, document, fileName, content };
  }

  // Helper to send update to global panel
  function sendGlobalUpdate() {
    if (!globalPanel) return;
    const { fileName, content } = getEditorInfo();
    globalPanel.webview.postMessage({
      type: "update",
      fileName,
      content,
    });
  }

  // ===========================================
  // Command 1: Global panel (tracks active editor)
  // Keybinding: Ctrl+Cmd+Delete / Ctrl+Meta+Backspace
  // ===========================================
  const openGlobalPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openPanel",
    () => {
      // If panel already exists, reveal it and update
      if (globalPanel) {
        globalPanel.reveal(vscode.ViewColumn.Beside);
        sendGlobalUpdate();
        log("Global panel revealed");
        return;
      }

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

      log(`Global panel created`);

      // Listen for active editor changes
      const editorChangeListener = vscode.window.onDidChangeActiveTextEditor(
        (editor) => {
          if (editor) {
            const fileName =
              editor.document.fileName.split("/").pop() ?? "Unknown";
            log(`Active editor changed: ${fileName}`);
            sendGlobalUpdate();
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
            sendGlobalUpdate();
          }
        },
      );

      globalPanel.onDidChangeViewState((e) => {
        const state = e.webviewPanel.visible ? "visible" : "hidden";
        log(`Global panel is now ${state}`);
      });

      globalPanel.onDidDispose(() => {
        editorChangeListener.dispose();
        contentChangeListener.dispose();
        globalPanel = undefined;
        log(`Global panel disposed`);
      });

      globalPanel.webview.html = getWebviewContent(
        globalPanel.webview,
        context.extensionUri,
      );

      sendGlobalUpdate();
    },
  );

  // ===========================================
  // Command 2: Per-editor panel (tied to specific file)
  // Keybinding: Cmd+Delete / Meta+Backspace
  // ===========================================
  const openEditorPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openEditorPanel",
    () => {
      const editor = vscode.window.activeTextEditor;
      const document = editor?.document;
      const fileName = document?.fileName.split("/").pop() ?? "Unknown";
      const content = document?.getText() ?? "";

      log(`Creating editor panel for: ${fileName}`);

      const panel = vscode.window.createWebviewPanel(
        "idiogloss-editor",
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

      log(`Editor panel created: ${fileName}`);

      // Send updates when THIS document changes
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
        log(`Editor panel ${fileName} is now ${state}`);
      });

      panel.onDidDispose(() => {
        changeListener.dispose();
        log(`Editor panel disposed: ${fileName}`);
      });

      panel.webview.html = getWebviewContent(
        panel.webview,
        context.extensionUri,
      );

      // Send initial data
      panel.webview.postMessage({
        type: "update",
        fileName,
        content,
      });
    },
  );

  context.subscriptions.push(openGlobalPanelCmd, openEditorPanelCmd);

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
