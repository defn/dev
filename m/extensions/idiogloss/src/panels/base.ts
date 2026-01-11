import * as vscode from "vscode";
import { log } from "../utils/logger";
import { generateWebviewHtml } from "../webview/content";

export interface PanelMessage {
  type: string;
  fileName: string;
  content: string;
}

export interface PanelOptions {
  viewType: string;
  title: string;
  extensionUri: vscode.Uri;
  retainContextWhenHidden?: boolean;
}

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
