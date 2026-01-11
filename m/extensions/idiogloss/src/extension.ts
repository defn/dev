import * as vscode from "vscode";
import { initLogger, log } from "./utils";
import { GlobalPanel, EditorPanel } from "./panels";
import { getAgentClient, disposeAgentClient } from "./agent";

async function startAgentServer(): Promise<boolean> {
  const workspaceFolders = vscode.workspace.workspaceFolders;
  if (!workspaceFolders) {
    log("[startup] No workspace folder open, cannot start agent server");
    return false;
  }

  const bazelWorkspace = workspaceFolders[0].uri.fsPath;
  const client = getAgentClient();

  try {
    log(`[startup] Starting agent server in ${bazelWorkspace}`);
    await client.startServer(bazelWorkspace);
    log("[startup] Server started, connecting...");
    await client.connect();
    log("[startup] Connected, sending ping...");
    const pong = await client.ping();
    if (pong) {
      log("[startup] Agent server started and connected successfully");
      return true;
    } else {
      log("[startup] Agent server started but ping failed");
      return false;
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    log(`[startup] Failed to start agent server: ${message}`);
    return false;
  }
}

export async function activate(context: vscode.ExtensionContext) {
  const outputChannel = initLogger();
  context.subscriptions.push(outputChannel);
  log("Extension activating...");

  // Auto-start the agent server
  startAgentServer();

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

  // Command: Query the agent
  const queryAgentCmd = vscode.commands.registerCommand(
    "idiogloss.queryAgent",
    async () => {
      const prompt = await vscode.window.showInputBox({
        prompt: "Enter your query for the agent",
        placeHolder: "What time is it?",
      });

      if (!prompt) {
        return;
      }

      const client = getAgentClient();

      try {
        if (!client.isConnected()) {
          vscode.window.showInformationMessage("Connecting to agent...");
          await client.connect();
        }

        vscode.window.showInformationMessage("Querying agent...");
        const response = await client.query(prompt);

        if (response.success) {
          vscode.window.showInformationMessage(
            response.response || "Agent completed successfully",
          );
        } else {
          vscode.window.showErrorMessage(
            `Agent error: ${response.error || "Unknown error"}`,
          );
        }
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        vscode.window.showErrorMessage(`Failed to query agent: ${message}`);
      }
    },
  );

  // Command: Start the agent server (manual trigger)
  const startAgentCmd = vscode.commands.registerCommand(
    "idiogloss.startAgent",
    async () => {
      vscode.window.showInformationMessage("Starting agent server...");
      const success = await startAgentServer();
      if (success) {
        vscode.window.showInformationMessage(
          "Agent server started and connected",
        );
      } else {
        vscode.window.showErrorMessage(
          "Failed to start agent server (check logs)",
        );
      }
    },
  );

  // Command: Stop the agent server
  const stopAgentCmd = vscode.commands.registerCommand(
    "idiogloss.stopAgent",
    async () => {
      const client = getAgentClient();
      await client.stopServer();
      vscode.window.showInformationMessage("Agent server stopped");
    },
  );

  context.subscriptions.push(
    openGlobalPanelCmd,
    openEditorPanelCmd,
    queryAgentCmd,
    startAgentCmd,
    stopAgentCmd,
  );

  log("Extension activated");
}

export async function deactivate() {
  log("Extension deactivating...");
  disposeAgentClient();
  log("Extension deactivated");
}
