(ns tutlib
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [promesa.core :as p]
            [clojure.string :as s]
            [tutorial :as tutorial]))

(defn- open-tutorial [tutorial_filename tutorial_webpage]
  ;; open tutorial main file
  (p/let [doc (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath tutorial_filename))
          meh (vscode/window.showTextDocument doc #js {:preview false, :preserveFocus false, :viewColumn: vscode/ViewColumn.One})]

    ;; open tutorial.html
    (p/let [panel (vscode/window.createWebviewPanel "Tutorial" "Tutorial" vscode/ViewColumn.Two #js {:enableScripts true})
            webpage (vscode/Uri.file (path/join vscode/workspace.rootPath tutorial_webpage))
            webdata (vscode/workspace.fs.readFile webpage)
            portpage (vscode/Uri.file (path/join vscode/workspace.rootPath ".app_port"))
            portdata (vscode/workspace.fs.readFile portpage)
            html (.decode (js/TextDecoder. "utf-8") webdata)
            url (vscode/env.asExternalUri (vscode/Uri.parse (str "http://localhost:" portdata)))]

      (set!  (.. panel -webview -html) (str (s/replace html "{{url}}" url))))))



