(ns dfd
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]))

(defn main []
  (p/let [terminal (vscode/window.createTerminal #js {:name "tutorial"})
          panel (vscode/window.createWebviewPanel "tutorial" "Tutorial" vscode/ViewColumn.One #js {:enableScripts true})
          uri (vscode/Uri.file (path/join vscode/workspace.rootPath "index.html"))
          data (vscode/workspace.fs.readFile uri)
          html (.decode (js/TextDecoder. "utf-8") data)]

    (doto (joyride/output-channel)
      (.appendLine "==============================================================")
      (.appendLine (str "Invoked script: " (joyride/invoked-script)))
      (.appendLine "=============================================================="))

    (set! (.. panel -webview -html) (str html))

    (doto terminal
      (.show true)
      (.sendText "make index.html"))

    (p/-> (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath "index.cue"))
          (vscode/window.showTextDocument #js {:preview false, :preserveFocus false}))
  ))

(when (= (joyride/invoked-script) joyride/*file*)
  (main))