/**
 * Utilities for accessing VS Code active editor information.
 */

import * as vscode from "vscode";

/** Information about an editor and its document */
export interface EditorInfo {
  editor: vscode.TextEditor | undefined;
  document: vscode.TextDocument | undefined;
  fileName: string;
  content: string;
}

/**
 * Get information about the currently active text editor.
 * @returns EditorInfo with editor, document, fileName, and content
 */
export function getActiveEditorInfo(): EditorInfo {
  const editor = vscode.window.activeTextEditor;
  const document = editor?.document;
  const fileName = document?.fileName.split("/").pop() ?? "No file";
  const content = document?.getText() ?? "";
  return { editor, document, fileName, content };
}

/**
 * Get information about a specific document.
 * @param document - The VS Code TextDocument to get info for
 * @returns EditorInfo with document details (editor will be undefined)
 */
export function getDocumentInfo(
  document: vscode.TextDocument | undefined,
): EditorInfo {
  const fileName = document?.fileName.split("/").pop() ?? "Unknown";
  const content = document?.getText() ?? "";
  return { editor: undefined, document, fileName, content };
}
