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
plugins=(git pip python vagrant npm supervisor)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/home/dshughe1/.rbenv/bin:/home/dshughe1/.rvm/gems/ruby-1.9.3-p194/bin:/home/dshughe1/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/dshughe1/.rvm/rubies/ruby-1.9.3-p194/bin:/home/dshughe1/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# Print the current color palette
function palette {
    for color in {000..255}; do
        echo "$FG[$color] ■ $color"
    done
    echo "%{$reset_color%}"
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# load aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# remap caps lock so it can be used as the tmux prefix key (see .tmux.conf)
setxkbmap
xmodmap -e "remove Lock = Caps_Lock" >> /dev/null 2>&1
xmodmap -e "keysym Caps_Lock = Prior" >> /dev/null 2>&1

# use vim as default editor
export EDITOR=/usr/bin/vim

# source tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

export NODE_PATH=/usr/local/lib/node_modules

# tell virtualenv not to change the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=true

function findenv() {
    # recursively look in ancestor directories to $PWD for a directory called 'env'
    # with a 'bin/activate' file and try to source it
    current_dir=$PWD 
    while (( ${#current_dir} > 1 )); do
        activate="$current_dir/env/bin/activate"
        if [[ -f  "$activate" ]]; then
            source $activate
            echo "Activated virtualenv: $current_dir/env"
            return
        fi
        current_dir=`dirname $current_dir`
    done
}

function mkenv {
    # create a virtualenv called 'env' in the current directory and initialize
    # with the usual settings and activate it
    if [[ -d env ]]; then
        echo "A virtualenv already exists in this directory"
        return
    else
        virtualenv --no-site-packages --python=python2.7 --distribute env
        source env/bin/activate
    fi
    
    # then, look for a 'requirements.txt' file and `pip install -r` it if found
    if [[ -f requirements.txt ]]; then
        echo "Updating pip dependencies"
        pip install -r requirements.txt
    fi
}
