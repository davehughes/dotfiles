(ns dot.venv
  (:require [dot.util :refer [pwd ancestors-and-self]]
            [babashka.fs :as fs]
            [babashka.process :refer [shell]]))

(defn- resolve-path [path]
  (if (nil? path) (pwd) path))

(defn dir-candidates [dirseq]
  (for [dir dirseq
        env-dir-name [".venv" "venv" "env"]]
    (str dir "/" env-dir-name)))

(defn env-binary-path [env-path binary]
  (str env-path "/bin/" binary))

(defn python-site-packages-dir [python-exe]
  (let [python-exe (if (nil? python-exe) "python" python-exe)
        python-code "import site; print(site.getsitepackages()[-1])"
        process (shell {:out :string :err :string} python-exe "-c" python-code)]
    (:out process)))

(defn find-env [path]
  (let [path (resolve-path path)
        dirseq (ancestors-and-self path)
        env (->> dirseq
                 (dir-candidates)
                 (filter #(fs/exists? (env-binary-path % "activate")))
                 first)]
    (if env
      {:root (str (fs/parent env))
       :venv-path env
       :activate-path (env-binary-path env "activate")
       :python-exe-path (env-binary-path env "python")
       :site-packages-dir (python-site-packages-dir (env-binary-path env "python"))}
      nil)))

;; (python-site-packages-dir nil)
