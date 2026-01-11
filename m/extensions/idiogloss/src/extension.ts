import * as vscode from "vscode";
import { initLogger, log } from "./utils";
import { GlobalPanel, EditorPanel } from "./panels";

export function activate(context: vscode.ExtensionContext) {
  const outputChannel = initLogger();
  context.subscriptions.push(outputChannel);
  log("Extension activating...");

  // Command: Open global panel (tracks active editor)
  const openGlobalPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openPanel",
    () => {
      GlobalPanel.create(context.extensionUri);
    },
  );

  // Command: Open per-editor panel (tied to specific file)
  const openEditorPanelCmd = vscode.commands.registerCommand(
    "idiogloss.openEditorPanel",
    () => {
      new EditorPanel(context.extensionUri);
    },
  );

  context.subscriptions.push(openGlobalPanelCmd, openEditorPanelCmd);

  log("Extension activated");
}

export function deactivate() {
  log("Extension deactivated");
}
