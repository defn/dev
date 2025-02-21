(ns tutlib
  (:require ["path" :as path]
            ["vscode" :as vscode]
            ["child_process" :as child-process]
            ["util" :as node-util]
            [promesa.core :as p]
            [clojure.string :as s]))

(defn open-tutorial [tutorial_filename tutorial_webpage]
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

(defn load-tutorial [edit_page lesson_page]
  (p/let [tutname(vscode/Uri.file (path/join vscode/workspace.rootPath ".app_tutorial"))
          tutdata (vscode/workspace.fs.readFile tutname)]
    (if (> (.-length tutdata) 0)
      (open-tutorial edit_page lesson_page))))

(def exec!+ (node-util/promisify child-process/exec))

(defn run-s6 []
  (-> (p/do!
       (exec!+ "source ~/.bash_profile; setsid mise run serve"
               #js {:cwd vscode/workspace.rootPath
                    :shell true}))
      (p/catch (fn [e]
                 (js/console.error "Error running s6-svscan:" e)))))

(defn tutorial [edit_page lesson_page]
  (tutlib.run-s6)
  (tutlib.load-tutorial edit_page lesson_page))
