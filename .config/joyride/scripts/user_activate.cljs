(ns user-activate
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]
            [dfd]))

(defonce !db (atom {:disposables []}))

;; To make the activation script re-runnable we dispose of
;; event handlers and such that we might have registered
;; in previous runs.
(defn- clear-disposables! []
  (run! (fn [disposable]
          (.dispose disposable))
        (:disposables @!db))
  (swap! !db assoc :disposables []))

;; Pushing the disposables on the extension context's
;; subscriptions will make VS Code dispose of them when the
;; Joyride extension is deactivated.
(defn- push-disposable [disposable]
  (swap! !db update :disposables conj disposable)
  (-> (joyride/extension-context)
      .-subscriptions
      (.push disposable)))

(defn tutorial []
  ;; open tutorial.cue
  (p/let [doc (vscode/workspace.openTextDocument (path/join vscode/workspace.rootPath "tutorial.cue"))
          meh (vscode/window.showTextDocument doc #js {:preview false, :preserveFocus false, :viewColumn: vscode/ViewColumn.One})]

    ;; split editor TODO does this execute async? if so, then it's not guaranteed the tutorial loads in column two
    (vscode/commands.executeCommand "workbench.action.moveEditorToPreviousGroup")

    ;; open tutorial.html
    (p/let [panel (vscode/window.createWebviewPanel "tutorial" "Tutorial" vscode/ViewColumn.Two #js {:enableScripts true})
            uri (vscode/Uri.file (path/join vscode/workspace.rootPath "tutorial.html"))
            data (vscode/workspace.fs.readFile uri)
            html (.decode (js/TextDecoder. "utf-8") data)]
      (set! (.. panel -webview -html) (str html))))

  ;; run command in terminal
  (p/let [terminal (vscode/window.createTerminal #js {:name "tutorial"})]
    (doto terminal
      (.show true)
      (.sendText "make tutorial"))))

(defn- main []
  (clear-disposables!)
  (push-disposable
    ;; It might surprise you to see how often and when this happens,
    ;; and when it doesn't happen.
    (vscode/workspace.onDidOpenTextDocument
      (fn [doc]
        (doto (joyride/output-channel)
          (.appendLine (str "on-did-open-text-document " (.-languageId doc) " " (.-fileName doc)))))))
    (tutorial)
    (dfd/main))

(when (= (joyride/invoked-script) joyride/*file*)
  (main))
