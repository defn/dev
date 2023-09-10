(ns dfd
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]))

(defn main []
    (doto (joyride/output-channel)
      (.appendLine "==============================================================")
      (.appendLine (str "Invoked script: " (joyride/invoked-script)))
      (.appendLine "=============================================================="))


    (p/let [doc (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath "index.cue"))
            meh (vscode/window.showTextDocument doc #js {:preview false, :preserveFocus false, :viewColumn: vscode/ViewColumn.One})]

      (vscode/commands.executeCommand "workbench.action.splitEditor")

      (p/let [panel (vscode/window.createWebviewPanel "tutorial" "Tutorial" vscode/ViewColumn.Two #js {:enableScripts true})
              uri (vscode/Uri.file (path/join vscode/workspace.rootPath "index.html"))
              data (vscode/workspace.fs.readFile uri)
              html (.decode (js/TextDecoder. "utf-8") data)]

        (set! (.. panel -webview -html) (str html))))

    (p/let [terminal (vscode/window.createTerminal #js {:name "tutorial"})]

      (doto terminal
        (.show true)
        (.sendText "make index.html")))

  )

(when (= (joyride/invoked-script) joyride/*file*)
  (main))