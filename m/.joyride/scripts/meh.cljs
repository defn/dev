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
    (set! (.. panel -webview -html) (str html))))

(when (= (joyride/invoked-script) joyride/*file*)
  (main))