(ns tutorial
  (:require [tutlib :as tutlib]
            [clojure.string :as s]))

(def tutorial_filename "src/content/docs/index.mdx")

(def tutorial_webpage "tutorial.html")

(def tutorial_url "http://localhost:4341")

(tutlib/open-tutorial tutorial_filename tutorial_webpage tutorial_url)