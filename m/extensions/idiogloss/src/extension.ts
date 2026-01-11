/**
 * idiogloss VS Code Extension
 *
 * Main entry point for the extension. Handles lifecycle management,
 * command registration, and agent server coordination.
 */

import * as vscode from "vscode";
import { initLogger, log } from "./utils";
import {
  GlobalPanel,
  EditorPanel,
  notifyPanelsServerConnected,
  notifyPanelsServerDisconnected,
} from "./panels";
import { getAgentClient, disposeAgentClient } from "./agent";

/** Status bar item for showing server state */
let statusBarItem: vscode.StatusBarItem | undefined;

function updateStatusBar(state: "starting" | "connected" | "disconnected") {
  if (!statusBarItem) {
    statusBarItem = vscode.window.createStatusBarItem(
      vscode.StatusBarAlignment.Right,
      100,
    );
    statusBarItem.command = "idiogloss.startAgent";
  }

  switch (state) {
    case "starting":
      statusBarItem.text = "$(sync~spin) Alucard awakening...";
      statusBarItem.tooltip = "Agent server starting (bazel run)";
      statusBarItem.backgroundColor = undefined;
      break;
    case "connected":
      statusBarItem.text = "$(flame) Alucard";
      statusBarItem.tooltip = "Agent server connected";
      statusBarItem.backgroundColor = undefined;
      break;
    case "disconnected":
      statusBarItem.text = "$(circle-slash) Alucard";
      statusBarItem.tooltip = "Agent server disconnected - click to start";
      statusBarItem.backgroundColor = new vscode.ThemeColor(
        "statusBarItem.warningBackground",
      );
      break;
  }
  statusBarItem.show();
}

/**
 * Starts the Python agent server and establishes a connection.
 * The server communicates via Unix socket at /tmp/idiogloss.sock.
 *
 * @returns Promise resolving to true if server started and connected successfully
 */
async function startAgentServer(): Promise<boolean> {
  const workspaceFolders = vscode.workspace.workspaceFolders;
  if (!workspaceFolders) {
    log("[startup] No workspace folder open, cannot start agent server");
    updateStatusBar("disconnected");
    return false;
  }

  const bazelWorkspace = workspaceFolders[0].uri.fsPath;
  const client = getAgentClient();

  updateStatusBar("starting");

  try {
    log(`[startup] Starting agent server in ${bazelWorkspace}`);
    log("[startup] This may take 10-20 seconds (bazel run)...");
    await client.startServer(bazelWorkspace);
    log("[startup] Server process started, connecting to socket...");
    await client.connect();
    log("[startup] Socket connected, sending ping...");
    const pong = await client.ping();
    if (pong) {
      log("[startup] Agent server started and connected successfully");
      updateStatusBar("connected");
      // Notify any panels that were created before server was ready
      notifyPanelsServerConnected();
      return true;
    } else {
      log("[startup] Agent server started but ping failed");
      updateStatusBar("disconnected");
      return false;
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    log(`[startup] Failed to start agent server: ${message}`);
    updateStatusBar("disconnected");
    return false;
  }
}

/**
 * Extension activation entry point.
 * Called by VS Code when the extension is first activated.
 *
 * Registers commands:
 * - idiogloss.openPanel: Open global tracking panel
 * - idiogloss.openEditorPanel: Open per-file panel
 * - idiogloss.queryAgent: Send prompt to agent
 * - idiogloss.startAgent: Manually start agent server
 * - idiogloss.stopAgent: Stop agent server
 *
 * @param context - VS Code extension context for managing subscriptions
 */
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
      updateStatusBar("disconnected");
      notifyPanelsServerDisconnected();
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

  // Add status bar to subscriptions for cleanup
  if (statusBarItem) {
    context.subscriptions.push(statusBarItem);
  }

  log("Extension activated");
}

/**
 * Extension deactivation handler.
 * Called by VS Code when the extension is being unloaded.
 * Cleans up agent client connection and server process.
 */
export async function deactivate() {
  log("Extension deactivating...");
  disposeAgentClient();
  log("Extension deactivated");
}
