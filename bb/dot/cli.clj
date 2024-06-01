(ns dot.cli
  (:require [clojure.tools.cli :refer [parse-opts]]
            [clojure.pprint]
            [dot.venv]))

;; CLI adapters
(defn venv-find-activate-script [& args]
  (let [path (first args)]
    (-> path dot.venv/find-env :activate-path print)))

(defn venv-find [& args]
  (let [path (first args)]
    (-> path dot.venv/find-env clojure.pprint/pprint)))

(def cli-options
  ;; An option with a required argument
  [["-p" "--port PORT" "Port number"
    :default 80
    :parse-fn #(Integer/parseInt %)
    :validate [#(< 0 % 0x10000) "Must be a number between 0 and 65536"]]
   ;; A non-idempotent option (:default is applied first)
   ["-v" nil "Verbosity level"
    :id :verbosity
    :default 0
    :update-fn inc] ; Prior to 0.4.1, you would have to use:
                   ;; :assoc-fn (fn [m k _] (update-in m [k] inc))
   ;; A boolean option defaulting to nil
   ["-h" "--help"]])

(defn -main [& args]
  (let [opts (parse-opts args cli-options)]
    (print opts)))
