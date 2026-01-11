/**
 * Base Panel - Abstract Webview Panel with Agent Integration
 *
 * Provides shared functionality for webview panels:
 * - Panel creation with security options
 * - Message passing to webview via postMessage
 * - Agent server communication (stats, alucard)
 * - Debounced content updates (2s idle before server request)
 * - Lifecycle management with proper disposal
 *
 * ## Webview Security
 *
 * Webviews run in an isolated iframe with restricted capabilities:
 * - `enableScripts: true` - Required for Svelte app to run
 * - `localResourceRoots` - Limits file access to dist/ folder only
 * - `retainContextWhenHidden: true` - Keeps state when panel hidden
 *
 * ## Why retainContextWhenHidden?
 *
 * Without this, VS Code destroys the webview's JavaScript context when
 * the panel is hidden (switching tabs, toggling terminal). When shown
 * again, it recreates from scratch - losing all state.
 *
 * Trade-off: Uses more memory. Acceptable for simple webviews.
 *
 * ## Panel Registry
 *
 * Active panels are tracked in `activePanels` Set for broadcasting
 * server status changes. When server connects/disconnects, all panels
 * are notified to update their UI.
 *
 * ## Content Update Flow
 *
 * 1. Editor content changes
 * 2. Subclass calls `onContentUpdate(fileName, content)`
 * 3. Debouncer waits 2s for idle
 * 4. `sendContentUpdate()` fires - requests stats + alucard
 * 5. Responses sent to webview via `sendMessage()`
 */

import * as vscode from "vscode";
import { log, Debouncer } from "../utils";
import { generateWebviewHtml } from "../webview/content";
import { getAgentClient, ContentStats, AgentProgressUpdate } from "../agent";

/** Debounce delay for content updates (milliseconds) */
const CONTENT_DEBOUNCE_DELAY = 2000;

/** Content update payload */
interface ContentUpdate {
  fileName: string;
  content: string;
}

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
  /** Progress update from agent */
  progress?: AgentProgressUpdate;
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

  /** Debouncer for content updates */
  private contentDebouncer: Debouncer<ContentUpdate>;

  constructor(options: PanelOptions) {
    this.extensionUri = options.extensionUri;

    // Initialize content debouncer
    this.contentDebouncer = new Debouncer<ContentUpdate>(
      CONTENT_DEBOUNCE_DELAY,
      (update) => this.sendContentUpdate(update),
      "panel",
    );

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
   */
  protected onContentUpdate(fileName: string, content: string): void {
    this.contentDebouncer.call({ fileName, content });
  }

  /**
   * Send content update to server (stats and alucard).
   */
  private async sendContentUpdate(update: ContentUpdate): Promise<void> {
    const { fileName, content } = update;
    log(`[panel] Sending content update for ${fileName}`);

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
      const response = await client.alucardWithProgress(
        text,
        (progress: AgentProgressUpdate) => {
          // Send progress update to webview
          log(`[panel] Progress: ${progress.type}`);
          this.sendMessage({
            type: "progress",
            progress,
          });
        },
      );
      log(
        `[panel] Alucard response: success=${response.success}, hasResponse=${!!response.alucard_response}`,
      );
      // Always send alucard message to clear loading state
      this.sendMessage({
        type: "alucard",
        alucard_response:
          response.alucard_response ||
          response.error ||
          "The vampire remains silent...",
      });
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log(`[panel] Failed to get alucard response: ${msg}`);
      // Clear loading state on error
      this.sendMessage({
        type: "alucard",
        alucard_response: `The summoning failed: ${msg}`,
      });
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

    // Cancel any pending debounced updates
    this.contentDebouncer.cancel();

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
    if (this.contentDebouncer.hasPending()) {
      log("[panel] Flushing queued update after server connection");
      this.contentDebouncer.flush();
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
