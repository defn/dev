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

/** Track all active panels for server status updates */
const activePanels: Set<BasePanel> = new Set();

/** Notify all active panels that the server is now connected */
export function notifyPanelsServerConnected(): void {
  log(`[panels] Notifying ${activePanels.size} panels of server connection`);
  for (const panel of activePanels) {
    panel.refreshServerInfo();
  }
}

/** Notify all active panels that the server is now disconnected */
export function notifyPanelsServerDisconnected(): void {
  log(`[panels] Notifying ${activePanels.size} panels of server disconnection`);
  for (const panel of activePanels) {
    panel.notifyDisconnected();
  }
}

/** Message sent from extension to webview via postMessage */
export interface PanelMessage {
  type: string;
  fileName?: string;
  content?: string;
  stats?: ContentStats;
  connected?: boolean;
  server_start_time?: number;
  server_pid?: number;
  alucard_response?: string;
  incantation?: string;
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

  /** Pending content update to send after debounce */
  private pendingUpdate: { fileName: string; content: string } | null = null;
  /** Debounce timer for content updates */
  private debounceTimer: NodeJS.Timeout | null = null;
  /** Debounce delay in milliseconds */
  private static readonly DEBOUNCE_DELAY = 3000;

  constructor(options: PanelOptions) {
    this.extensionUri = options.extensionUri;

    // Track this panel for server status updates
    activePanels.add(this);

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
   * Called after content is sent to webview. Debounces server requests.
   * Waits 3 seconds of idle before sending to server.
   */
  protected onContentUpdate(fileName: string, content: string): void {
    // Store pending update
    this.pendingUpdate = { fileName, content };

    // Clear existing timer
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }

    // Set new debounce timer
    this.debounceTimer = setTimeout(() => {
      this.sendPendingUpdate();
    }, BasePanel.DEBOUNCE_DELAY);

    log(
      `[panel] Content update queued, waiting ${BasePanel.DEBOUNCE_DELAY}ms for idle`,
    );
  }

  /**
   * Send pending update to server (stats and alucard).
   */
  private async sendPendingUpdate(): Promise<void> {
    if (!this.pendingUpdate) {
      return;
    }

    const { fileName, content } = this.pendingUpdate;
    log(`[panel] Sending pending update for ${fileName}`);

    // Request stats from server
    this.requestStats(fileName, content);

    // Send the first line of content to Alucard for transformation
    const firstLine = content.split("\n")[0] || fileName;
    this.requestAlucard(firstLine);
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
   * Request Alucard transformation of text and send response to webview.
   */
  protected async requestAlucard(text: string): Promise<void> {
    const client = getAgentClient();
    const isConnected = client.isConnected();
    log(`[panel] requestAlucard: isConnected=${isConnected}`);

    if (!isConnected) {
      log("[panel] Server not connected, cannot request alucard");
      this.sendMessage({ type: "serverStatus", connected: false });
      return;
    }

    // Notify webview that we're summoning Alucard
    this.sendMessage({
      type: "summoning",
      incantation: text,
    } as PanelMessage);

    try {
      log("[panel] Sending alucard request to server...");
      const response = await client.alucard(text);
      log(`[panel] Alucard response: success=${response.success}`);
      if (response.success && response.alucard_response) {
        this.sendMessage({
          type: "alucard",
          alucard_response: response.alucard_response,
        });
      } else if (response.error) {
        log(`[panel] Alucard error: ${response.error}`);
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log(`[panel] Failed to get alucard response: ${msg}`);
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
    // Remove from active panels tracking
    activePanels.delete(this);

    for (const disposable of this.disposables) {
      disposable.dispose();
    }
    this.disposables = [];
    this.onDispose();
  }

  /**
   * Refresh server info - called when server connects after panel was created.
   * Also sends any pending updates that were queued while server was starting.
   */
  public refreshServerInfo(): void {
    log("[panel] Refreshing server info after connection");
    this.requestServerInfo();

    // Send any pending update that was queued while server was starting
    if (this.pendingUpdate) {
      log("[panel] Sending queued update after server connection");
      this.sendPendingUpdate();
    }
  }

  /**
   * Notify webview that server is disconnected.
   */
  public notifyDisconnected(): void {
    log("[panel] Notifying webview of server disconnection");
    this.sendMessage({ type: "serverStatus", connected: false });
  }

  protected abstract onDispose(): void;

  public get webviewPanel(): vscode.WebviewPanel {
    return this.panel;
  }
}
