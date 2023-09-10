(ns meh
  (:require ["path" :as path]
            ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]))

(defn main []
  (p/let [terminal (vscode/window.createTerminal #js {:name "dfd"}) ]
    (doto (joyride/output-channel)
      (.appendLine "==============================================================")
      (.appendLine (str "Invoked script: " (joyride/invoked-script)))
      (.appendLine "=============================================================="))
    (doto terminal
      (.show true)
      (.sendText "ps axuf"))
  ))

(when (= (joyride/invoked-script) joyride/*file*)
  (main))