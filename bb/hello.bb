#!/usr/bin/env bb
(ns hello
  (:require [babashka.fs :as fs]))

(defn pwd []
  (System/getProperty "user.dir"))

(defn ancestors-and-self [path]
  (if (nil? path)
    []
    (lazy-seq (cons (str path) (ancestors-and-self (fs/parent path))))))

(defn venv-dir-candidates [dirseq]
  (for [dir dirseq
        env-dir-name [".venv" "venv" "env"]]
    {:root dir
     :env-path (str dir "/" env-dir-name)
     :activate-path (str dir "/" env-dir-name "/bin/activate")
     }))

(defn venv-find [path]
  (let [dirseq (ancestors-and-self path)
        candidates (venv-dir-candidates dirseq)
        filtered-candidates (filter #(fs/exists? (:activate-path %)) candidates)]
    (-> filtered-candidates first)))

(defn venv-activate [path]
  (:activate-path (venv-find path)))

(defn venv-test [path]
  (let [path (if (nil? path) (pwd) path)]
    (println (venv-activate path))))
