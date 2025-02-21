(ns workspace-activate
  (:require ["child_process" :as child-process]
            ["vscode" :as vscode]
            ["util" :as node-util]
            [promesa.core :as p]
            [tutlib :as tutlib]))

(def exec!+ (node-util/promisify child-process/exec))

(defn run-s6 []
  (-> (p/do!
       (exec!+ "source ~/.bash_profile; setsid mise run serve"
               #js {:cwd vscode/workspace.rootPath
                    :shell true}))
      (p/catch (fn [e]
                 (js/console.error "Error running s6-svscan:" e)))))

(run-s6)
(tutlib.load-tutorial "src/pages/index.astro" "tutorial.html")

