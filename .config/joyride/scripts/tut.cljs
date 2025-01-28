(ns tut
  (:require [joyride.core :as joyride]
            [tutlib :as tutlib]))

(when (= (joyride/invoked-script) joyride/*file*)
  (tutlib.load-tutorial "src/pages/index.astro" "tutorial.html"))
