if test -z $TMUX && [[ $TERM != "screen-256color" ]]; then
    exec tmux
fi


# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="davehughes"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Don't rename the terminal, it's likely a tmux window that I already named
DISABLE_AUTO_TITLE=true

setopt nocorrectall

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(gitfast pip python vagrant npm supervisor autojump lol osx tmux tmuxinator)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:~/bin
EXPECTED_USERS=(d dave dshughe1)

# Enable autojump completion
autoload -U compinit && compinit

# Print the current color palette
function palette {
    COLORS=()
    for color in {000..255}; do
        COLORS+=("$FG[$color] ■ $color")
    done
    echo "${(j:\n:)COLORS}%{$reset_color%}"
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

PATH=/usr/local/share/python:/usr/local/Cellar/ruby/2.0.0-p0/bin:$PATH
PATH=/usr/local/Cellar/python/2.7.6/Frameworks/Python.framework/Versions/2.7:$PATH

# load aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# use vim as default editor
export EDITOR=/usr/local/bin/vim

# source tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

export NODE_PATH=/usr/local/lib/node_modules

# tell virtualenv not to change the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=true

export VIMCLOJURE_SERVER_JAR=~/bin/ng-server.jar

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

DOCKER_ROOT=~/projects/docker
function docker-build {
    pushd $DOCKER_ROOT/$1 >> /dev/null
    docker build -t $1 .
    popd >> /dev/null
}

function decap {
    # remap caps lock so it can be used as the tmux prefix key (see .tmux.conf)
    setxkbmap
    if [[ "$1" == "1" || "$1" == "true" ]]; then; xdotool key Caps_Lock; fi
    xmodmap -e "remove Lock = Caps_Lock" >/dev/null 2>&1
    xmodmap -e "keysym Caps_Lock = Prior" >/dev/null 2>&1
}

function DECAP {
    decap true
}

# decap false
# Load local shell config
LOCAL_SHELL_CONFIG=~/.local.zshrc
if [[ -f  $LOCAL_SHELL_CONFIG ]]; then
    source $LOCAL_SHELL_CONFIG
fi
