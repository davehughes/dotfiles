{:user {:plugins  [[lein-pprint "1.1.1"]
                   [com.palletops/lein-shorthand "0.4.0"]
                   [com.jakemccrary/lein-test-refresh "0.16.0"]
                   ; [venantius/ultra "0.5.1"]
                   ]

        :dependencies  [[slamhound "1.3.1"]
						[alembic "0.3.2"]
                        [pjstadig/humane-test-output "0.8.0"]
                        ]

        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!) 
                     ]

        :shorthand {. {pp      clojure.pprint/pprint
                       distill alembic.still/distill
                       lein    alembic.still/lein
                       }}

        :test-refresh {:notify-command ["notify-send"]
                       :quiet true
                       :changes-only true
                       }
        }}
