# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

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
