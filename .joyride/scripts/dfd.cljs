(ns dfd
  (:require ["vscode" :as vscode]
            [joyride.core :as joyride]
            [promesa.core :as p]))

(defn main []
  (doto (joyride/output-channel)
    (.appendLine "==============================================================")
    (.appendLine (str "Invoked script: " (joyride/invoked-script)))
    (.appendLine "=============================================================="))

  (p/let [terminal (vscode/window.createTerminal #js {:name "dfd"}) ]
    (doto terminal
      (.show true)
      (.sendText "ps axuf")))
)

(when (= (joyride/invoked-script) joyride/*file*)
  (main))