# .zshenv is always sourced, define here exported variables that should
# be available to other programs.
export EDITOR=nvim
export PAGER=less
export TERM="xterm-256color"

# Don't rename the terminal, it's likely a tmux window that I already named
DISABLE_AUTO_TITLE=true

# Customize PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:~/bin

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

PATH=$PATH:~/.gvm/bin
export PATH

# load zsh config files
env_config_files=(~/.zsh/**/*.zshenv(N))
if test ! -z "$env_config_files" ;
    then
    for file in ${env_config_files}
    do
      source $file
    done
fi
