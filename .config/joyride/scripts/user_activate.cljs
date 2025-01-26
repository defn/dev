(ns user-activate
  (:require ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]
            [tutlib :as tutlib]
            [tutorial :as tutorial]))

;;; user_activate.cljs skeleton

;; Keep tally on VS Code disposables we register
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
;; Joyride extension is deactivated, or when you rerun
;; `my-main` in this ns (such as rerunning this script).
(defn- push-disposable! [disposable]
  (swap! !db update :disposables conj disposable)
  (-> (joyride/extension-context)
      .-subscriptions
      (.push disposable)))

(defn- my-main []
  (p/let [tutname(vscode/Uri.file (path/join vscode/workspace.rootPath ".app_tutorial"))
          tutdata (vscode/workspace.fs.readFile tutname)]
    (if (> (.-length tutdata) 0)
      (tutlib.open-tutorial tutorial.edit_page tutorial.lesson_page)))
  (clear-disposables!))

(when (= (joyride/invoked-script) joyride/*file*)
  (my-main))
