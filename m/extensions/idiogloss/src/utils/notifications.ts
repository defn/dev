/**
 * Auto-dismissing notification utilities.
 */

import * as vscode from "vscode";

/**
 * Show an information message that auto-dismisses after a timeout.
 */
export function showAutoMessage(
  message: string,
  timeout: number = 500,
): Thenable<void> {
  return vscode.window.withProgress(
    {
      location: vscode.ProgressLocation.Notification,
      title: message,
      cancellable: false,
    },
    async () => {
      await new Promise((resolve) => setTimeout(resolve, timeout));
    },
  );
}
