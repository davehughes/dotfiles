function findenv() {
    # recursively look in ancestor directories to $PWD for a directory called 'env'
    # with a 'bin/activate' file and try to source it
    if [ "$1" != "" ]; then; DIR=$1; else; DIR=$PWD; fi
    ACTIVATE=$DIR/env/bin/activate

    if [[ -f  $ACTIVATE ]]; then
        source $ACTIVATE
        echo "Activated virtualenv: $DIR/env"
        return
    else
        PARENT=$(dirname $DIR)
        if [[ "$PARENT" == "$DIR" ]]; then
            echo "Couldn't locate a virtualenv"
        else
            findenv $PARENT
        fi
    fi
}

function mkenv {
    # create a virtualenv called 'env' in the current directory and initialize
    # with the usual settings and activate it
    if [ "$1" != "" ]; then; DIR=$1; else; DIR=$PWD; fi
    ENV=$DIR/env
    REQS=$ENV/requirements.txt

    if [[ -d $ENV ]]; then
        echo "A virtualenv already exists in this directory"
        return
    else
        virtualenv --no-site-packages --python=python2.7 --distribute $ENV
        source $ENV/bin/activate
    fi
    
    # then, look for a 'requirements.txt' file and `pip install -r` it if found
    if [[ -f $REQS ]]; then
        echo "Updating pip dependencies"
        pip install -r $REQS
    fi
}

# Attempt to findenv upon opening shell
findenv

