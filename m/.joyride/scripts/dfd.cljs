(ns dfd
  (:require [joyride.core :as joyride]))

(defn main []
  (doto (joyride/output-channel)
    (.appendLine (str "Invoked script: " (joyride/invoked-script)))))

(when (= (joyride/invoked-script) joyride/*file*)
  (main))