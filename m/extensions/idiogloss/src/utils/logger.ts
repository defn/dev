import * as vscode from "vscode";
import * as fs from "fs";

const LOG_FILE = "/tmp/idiogloss-extension.log";

let outputChannel: vscode.OutputChannel | undefined;

export function initLogger(): vscode.OutputChannel {
  if (!outputChannel) {
    outputChannel = vscode.window.createOutputChannel("idiogloss");
    // Write startup marker to log file
    const timestamp = new Date().toISOString();
    const startMsg = `\n${"=".repeat(50)}\n[${timestamp}] Extension logger initialized\n`;
    fs.appendFileSync(LOG_FILE, startMsg);
  }
  return outputChannel;
}

export function log(message: string): void {
  if (!outputChannel) {
    initLogger();
  }
  const timestamp = new Date().toISOString();
  const formattedMsg = `[${timestamp}] ${message}`;

  // Write to VS Code output channel
  outputChannel!.appendLine(formattedMsg);

  // Also write to file for debugging
  try {
    fs.appendFileSync(LOG_FILE, formattedMsg + "\n");
  } catch {
    // Ignore file write errors
  }
}

export function getOutputChannel(): vscode.OutputChannel | undefined {
  return outputChannel;
}
