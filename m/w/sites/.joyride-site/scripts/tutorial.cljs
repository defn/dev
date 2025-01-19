(ns tutorial
  (:require [tutlib :as tutlib]))

(def tutorial_filename "src/content/docs/index.mdx")

(def tutorial_webpage "tutorial.html")


(tutlib/open-tutorial tutorial_filename tutorial_webpage)
