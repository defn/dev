/**
 * Editor panel module - per-file panel tied to a specific document.
 */

import * as vscode from "vscode";
import { BasePanel, PanelOptions } from "./base";
import { log } from "../utils/logger";

/**
 * Webview panel tied to a specific file/document.
 *
 * Unlike GlobalPanel (singleton tracking active editor), EditorPanel:
 * - Creates a new instance for each file
 * - Only updates when its specific document changes
 * - Panel title shows the filename
 *
 * Multiple EditorPanels can exist simultaneously for different files.
 */
export class EditorPanel extends BasePanel {
  private readonly document: vscode.TextDocument | undefined;
  private readonly fileName: string;
  private contentChangeListener: vscode.Disposable | undefined;

  constructor(extensionUri: vscode.Uri) {
    const editor = vscode.window.activeTextEditor;
    const document = editor?.document;
    const fileName = document?.fileName.split("/").pop() ?? "Unknown";

    const options: PanelOptions = {
      viewType: "idiogloss-editor",
      title: `idiogloss: ${fileName}`,
      extensionUri,
    };
    super(options);

    this.document = document;
    this.fileName = fileName;

    log(`Editor panel created: ${fileName}`);
    this.sendUpdate();
    this.requestServerInfo();
  }

  protected setupListeners(): void {
    // Listen for changes to THIS specific document only
    this.contentChangeListener = vscode.workspace.onDidChangeTextDocument(
      (e) => {
        if (
          this.document &&
          e.document.uri.toString() === this.document.uri.toString()
        ) {
          this.sendUpdate();
        }
      },
    );
    this.disposables.push(this.contentChangeListener);
  }

  protected onViewStateChanged(state: string): void {
    log(`Editor panel ${this.fileName} is now ${state}`);
  }

  protected onDispose(): void {
    log(`Editor panel disposed: ${this.fileName}`);
  }

  private async sendUpdate(): Promise<void> {
    const content = this.document?.getText() ?? "";
    this.sendMessage({
      type: "update",
      fileName: this.fileName,
      content,
    });
    // Request stats from server (async, don't block)
    this.requestStats(this.fileName, content);
  }
}
