{:user {:plugins  [[lein-pprint "1.1.1"]
                   [com.gfredericks/lein-shorthand "0.4.1"]
                   [com.jakemccrary/lein-test-refresh "0.16.0"]
                   [lein-exec "0.3.7"]
                   [lein-cljfmt "0.8.0"]
                   [http-kit/lein-template "1.0.0-SNAPSHOT"]
                   ; [venantius/ultra "0.5.1"]
                   ]

        :dependencies  [
                        [alembic "0.3.2"]
                        [borkdude/jet "0.0.6"]
                        ;; [pjstadig/humane-test-output "0.8.0"]
                        [slamhound "1.3.1"]
                        ]

        ;; :injections [(require 'pjstadig.humane-test-output)
        ;;              (pjstadig.humane-test-output/activate!)
        ;;              ]

        :aliases {"jet" ["run" "-m" "jet.main"]}

        :shorthand {. {pp      clojure.pprint/pprint
                       distill alembic.still/distill
                       lein    alembic.still/lein
                       }}

        :test-refresh {:notify-command ["notify-send"]
                       :quiet true
                       :changes-only true
                       }
        }}
