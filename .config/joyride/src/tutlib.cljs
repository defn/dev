(ns tutlib
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [promesa.core :as p]
            [clojure.string :as s]
            [tutorial :as tutorial]))

(defn- open-tutorial [tutorial_filename tutorial_webpage]
    (p/let [
            webpage (vscode/Uri.file (path/join vscode/workspace.rootPath tutorial_webpage))
            webdata (vscode/workspace.fs.readFile webpage)
            webhtml (.decode (js/TextDecoder. "utf-8") webdata)
            portpage (vscode/Uri.file (path/join vscode/workspace.rootPath ".app_port"))
            portdata (vscode/workspace.fs.readFile portpage)
            url (vscode/env.asExternalUri (vscode/Uri.parse (str "http://localhost:" portdata)))
            sfname (vscode/Uri.file (path/join vscode/workspace.rootPath ".app_up"))
            sdata (vscode/workspace.fs.readFile sfname)]
      (if (> (.-length sdata) 0)
        (do
          (p/let [
                  doc (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath tutorial_filename))
                  meh (vscode/window.showTextDocument doc #js {:preview false, :preserveFocus false, :viewColumn: vscode/ViewColumn.One})
                  panel (vscode/window.createWebviewPanel "Tutorial" "Tutorial" vscode/ViewColumn.Two #js {:enableScripts true})]
            (set!  (.. panel -webview -html) (str (s/replace webhtml "{{url}}" url)))))
        (do
          (js/console.log (str "sleeping..." sdata "."))
          (js/setTimeout 
            (fn [] (do
              (open-tutorial tutorial_filename tutorial_webpage)))
            1000)))))


