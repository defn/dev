(ns meh
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]))

(defn main []
  (p/let [panel (vscode/window.createWebviewPanel
                 "" "Tutorial"
                 vscode/ViewColumn.One
                 #js {:enableScripts true})
          uri (vscode/Uri.file (path/join vscode/workspace.rootPath
                                          "index.html"))
          data (vscode/workspace.fs.readFile uri)
          html (.decode (js/TextDecoder. "utf-8") data)]
    (doto (joyride/output-channel)
      (.appendLine "==============================================================")
      (.appendLine (str "Invoked script: " (joyride/invoked-script)))
      (.appendLine "=============================================================="))
    (set! (.. panel -webview -html) (str html))
    (let [terminal (vscode/window.createTerminal #js {:name "dfd"})]
        (.show terminal true)
        (.sendText terminal "make"))
    (path/join vscode/workspace.rootPath)
  ))

(when (= (joyride/invoked-script) joyride/*file*)
  (main))