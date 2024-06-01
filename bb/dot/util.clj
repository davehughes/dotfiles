(ns dot.util
  (:require [babashka.fs :as fs]))

(defn pwd []
  (System/getProperty "user.dir"))

(defn ancestors-and-self [path]
  (if (nil? path)
    []
    (lazy-seq (cons (str path) (ancestors-and-self (fs/parent path))))))
