import * as vscode from "vscode";

let outputChannel: vscode.OutputChannel | undefined;

export function initLogger(): vscode.OutputChannel {
  if (!outputChannel) {
    outputChannel = vscode.window.createOutputChannel("idiogloss");
  }
  return outputChannel;
}

export function log(message: string): void {
  if (!outputChannel) {
    initLogger();
  }
  const timestamp = new Date().toISOString();
  outputChannel!.appendLine(`[${timestamp}] ${message}`);
}

export function getOutputChannel(): vscode.OutputChannel | undefined {
  return outputChannel;
}
