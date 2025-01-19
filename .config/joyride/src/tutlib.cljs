(ns tutlib
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [promesa.core :as p]
            [tutorial :as tutorial]))

(defn- open-tutorial [tutorial_filename, tutorial_webpage]
  ;; open tutorial main file
  (p/let [doc (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath tutorial_filename))
          meh (vscode/window.showTextDocument doc #js {:preview false, :preserveFocus false, :viewColumn: vscode/ViewColumn.One})]

    ;; open tutorial.html
    (p/let [panel (vscode/window.createWebviewPanel "Tutorial" "Tutorial" vscode/ViewColumn.Two #js {:enableScripts true})
            uri (vscode/Uri.file (path/join vscode/workspace.rootPath tutorial_webpage))
            data (vscode/workspace.fs.readFile uri)
            html (.decode (js/TextDecoder. "utf-8") data)]
      (set! (.. panel -webview -html) (str html)))))

