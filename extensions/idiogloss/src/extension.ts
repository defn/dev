import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  console.log("Idiogloss extension is now active");

  const helloCmd = vscode.commands.registerCommand("idiogloss.hello", () => {
    vscode.window.showInformationMessage("Hello from Idiogloss!");
  });

  context.subscriptions.push(helloCmd);
}

export function deactivate() {}
