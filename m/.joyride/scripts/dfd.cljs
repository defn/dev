(ns dfd
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]))

(defn main []
  ; open index.cue
  (p/let [doc (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath "index.cue"))
          meh (vscode/window.showTextDocument doc #js {:preview false, :preserveFocus false, :viewColumn: vscode/ViewColumn.One})]

    ; split editor TODO does this execute async? if so, then it's not guaranteed the tutorial loads in column two
    (vscode/commands.executeCommand "workbench.action.moveEditorToPreviousGroup")

    ; open index.html
    (p/let [panel (vscode/window.createWebviewPanel "tutorial" "Tutorial" vscode/ViewColumn.Two #js {:enableScripts true})
            uri (vscode/Uri.file (path/join vscode/workspace.rootPath "index.html"))
            data (vscode/workspace.fs.readFile uri)
            html (.decode (js/TextDecoder. "utf-8") data)]
      (set! (.. panel -webview -html) (str html))))

  ; run command in terminal
  (p/let [terminal (vscode/window.createTerminal #js {:name "tutorial"})]
    (doto terminal
      (.show true)
      (.sendText "make index.html")))
)

(when (= (joyride/invoked-script) joyride/*file*)
  (main))