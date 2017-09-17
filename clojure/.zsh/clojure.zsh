function clj-repl-server () {
    JVM_OPTS="-Dclojure.server.myrepl={:port,${PORT:-50505},:accept,clojure.core.server/repl}" lein repl

    # Alternative, non-Lein version:
    # boot socket-server --port ${PORT:-50505} wait
}

function clj-repl () {
    unravel localhost ${PORT:-50505}
}
