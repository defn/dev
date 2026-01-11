/**
 * Base panel module for idiogloss webview panels.
 *
 * Provides abstract BasePanel class with shared functionality for
 * creating webview panels, handling messages, and managing lifecycle.
 */

import * as vscode from "vscode";
import { log } from "../utils/logger";
import { generateWebviewHtml } from "../webview/content";
import { getAgentClient, ContentStats } from "../agent";

/** Message sent from extension to webview via postMessage */
export interface PanelMessage {
  type: string;
  fileName?: string;
  content?: string;
  stats?: ContentStats;
  connected?: boolean;
  server_start_time?: number;
  server_pid?: number;
}

export interface PanelOptions {
  viewType: string;
  title: string;
  extensionUri: vscode.Uri;
  retainContextWhenHidden?: boolean;
}

/**
 * Abstract base class for webview panels.
 *
 * Provides common functionality:
 * - Webview panel creation with security options
 * - Message passing to webview via postMessage()
 * - Lifecycle management (dispose pattern)
 * - Agent server communication (stats, ping)
 *
 * Subclasses must implement:
 * - setupListeners(): Configure VS Code event listeners
 * - onViewStateChanged(): Handle panel visibility changes
 * - onDispose(): Cleanup when panel is closed
 */
export abstract class BasePanel {
  protected panel: vscode.WebviewPanel;
  protected disposables: vscode.Disposable[] = [];
  protected readonly extensionUri: vscode.Uri;

  constructor(options: PanelOptions) {
    this.extensionUri = options.extensionUri;

    this.panel = vscode.window.createWebviewPanel(
      options.viewType,
      options.title,
      vscode.ViewColumn.Beside,
      {
        enableScripts: true,
        retainContextWhenHidden: options.retainContextWhenHidden ?? true,
        localResourceRoots: [vscode.Uri.joinPath(options.extensionUri, "dist")],
      },
    );

    this.panel.webview.html = generateWebviewHtml(
      this.panel.webview,
      options.extensionUri,
    );

    this.panel.onDidChangeViewState(
      (e) => {
        const state = e.webviewPanel.visible ? "visible" : "hidden";
        this.onViewStateChanged(state);
      },
      null,
      this.disposables,
    );

    this.panel.onDidDispose(
      () => {
        this.dispose();
      },
      null,
      this.disposables,
    );

    this.setupListeners();
  }

  protected abstract setupListeners(): void;
  protected abstract onViewStateChanged(state: string): void;

  protected sendMessage(message: PanelMessage): void {
    this.panel.webview.postMessage(message);
  }

  /**
   * Request stats from the server and send to webview.
   */
  protected async requestStats(
    fileName: string,
    content: string,
  ): Promise<void> {
    const client = getAgentClient();
    const isConnected = client.isConnected();
    log(`[panel] requestStats: isConnected=${isConnected}, file=${fileName}`);

    if (!isConnected) {
      log("[panel] Server not connected, using local stats");
      this.sendMessage({ type: "serverStatus", connected: false });
      return;
    }

    try {
      log("[panel] Sending stats request to server...");
      const response = await client.getStats(fileName, content);
      log(`[panel] Stats response: success=${response.success}`);
      if (response.success && response.stats) {
        this.sendMessage({
          type: "stats",
          stats: response.stats,
        });
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log(`[panel] Failed to get stats: ${msg}`);
      this.sendMessage({ type: "serverStatus", connected: false });
    }
  }

  /**
   * Request server info via ping and send to webview.
   */
  protected async requestServerInfo(): Promise<void> {
    const client = getAgentClient();
    const isConnected = client.isConnected();
    log(`[panel] requestServerInfo: isConnected=${isConnected}`);

    if (!isConnected) {
      log("[panel] Server not connected, sending serverStatus=false");
      this.sendMessage({ type: "serverStatus", connected: false });
      return;
    }

    try {
      log("[panel] Sending ping to server...");
      const response = await client.send({ action: "ping" });
      log(
        `[panel] Ping response: pong=${response.pong}, pid=${response.server_pid}`,
      );
      if (response.pong) {
        this.sendMessage({
          type: "serverInfo",
          connected: true,
          server_start_time: response.server_start_time,
          server_pid: response.server_pid,
        } as PanelMessage);
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log(`[panel] Ping failed: ${msg}`);
      this.sendMessage({ type: "serverStatus", connected: false });
    }
  }

  public reveal(): void {
    this.panel.reveal(vscode.ViewColumn.Beside);
  }

  public dispose(): void {
    for (const disposable of this.disposables) {
      disposable.dispose();
    }
    this.disposables = [];
    this.onDispose();
  }

  protected abstract onDispose(): void;

  public get webviewPanel(): vscode.WebviewPanel {
    return this.panel;
  }
}
