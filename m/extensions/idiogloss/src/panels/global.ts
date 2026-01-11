import * as vscode from "vscode";
import { BasePanel, PanelOptions } from "./base";
import { log } from "../utils/logger";
import { getActiveEditorInfo } from "../utils/editor";

let instance: GlobalPanel | undefined;

export class GlobalPanel extends BasePanel {
  private editorChangeListener: vscode.Disposable | undefined;
  private contentChangeListener: vscode.Disposable | undefined;

  private constructor(extensionUri: vscode.Uri) {
    const options: PanelOptions = {
      viewType: "idiogloss",
      title: "idiogloss",
      extensionUri,
    };
    super(options);
    log("Global panel created");
  }

  public static create(extensionUri: vscode.Uri): GlobalPanel {
    if (instance) {
      instance.reveal();
      instance.sendUpdate();
      instance.requestServerInfo();
      log("Global panel revealed");
      return instance;
    }

    instance = new GlobalPanel(extensionUri);
    instance.sendUpdate();
    instance.requestServerInfo();
    return instance;
  }

  public static getInstance(): GlobalPanel | undefined {
    return instance;
  }

  protected setupListeners(): void {
    // Listen for active editor changes
    this.editorChangeListener = vscode.window.onDidChangeActiveTextEditor(
      (editor) => {
        if (editor) {
          const fileName =
            editor.document.fileName.split("/").pop() ?? "Unknown";
          log(`Active editor changed: ${fileName}`);
          this.sendUpdate();
        }
      },
    );
    this.disposables.push(this.editorChangeListener);

    // Listen for document content changes
    this.contentChangeListener = vscode.workspace.onDidChangeTextDocument(
      (e) => {
        const activeDoc = vscode.window.activeTextEditor?.document;
        if (
          activeDoc &&
          e.document.uri.toString() === activeDoc.uri.toString()
        ) {
          this.sendUpdate();
        }
      },
    );
    this.disposables.push(this.contentChangeListener);
  }

  protected onViewStateChanged(state: string): void {
    log(`Global panel is now ${state}`);
  }

  protected onDispose(): void {
    instance = undefined;
    log("Global panel disposed");
  }

  public async sendUpdate(): Promise<void> {
    const { fileName, content } = getActiveEditorInfo();
    this.sendMessage({
      type: "update",
      fileName,
      content,
    });
    // Request stats from server (async, don't block)
    this.requestStats(fileName, content);
  }
}
