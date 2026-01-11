import * as vscode from "vscode";

export interface EditorInfo {
  editor: vscode.TextEditor | undefined;
  document: vscode.TextDocument | undefined;
  fileName: string;
  content: string;
}

export function getActiveEditorInfo(): EditorInfo {
  const editor = vscode.window.activeTextEditor;
  const document = editor?.document;
  const fileName = document?.fileName.split("/").pop() ?? "No file";
  const content = document?.getText() ?? "";
  return { editor, document, fileName, content };
}

export function getDocumentInfo(
  document: vscode.TextDocument | undefined,
): EditorInfo {
  const fileName = document?.fileName.split("/").pop() ?? "Unknown";
  const content = document?.getText() ?? "";
  return { editor: undefined, document, fileName, content };
}
