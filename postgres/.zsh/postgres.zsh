# Set up postgres passwords file and define connection aliases
# """
# # alias:whatever
# host:port:database:user:password
# ""
# which is converted to:
# "pg-connect whatever" => "psql -H host -p port -U user database"
export PGPASSFILE=~/.pgpass
PG_CONNECT_SCRIPT=~/bin/pgpass.py

function pg-connect () {
    PSQL_COMMAND=$($PG_CONNECT_SCRIPT print-connection-command $@)
    echo "pg-connect $1 => $PSQL_COMMAND"
    sh -c "$PSQL_COMMAND"
}

function pg-list () {
    $PG_CONNECT_SCRIPT list
}

function pg-edit () {
    $EDITOR ~/.pgpass
}
