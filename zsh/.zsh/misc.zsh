# Enable autojump completion
autoload -U compinit && compinit

# load aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# source tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

export NODE_PATH=/usr/local/lib/node_modules

# tell virtualenv not to change the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Load local shell config
LOCAL_SHELL_CONFIG=~/.local.zshrc
if [[ -f  $LOCAL_SHELL_CONFIG ]]; then
    source $LOCAL_SHELL_CONFIG
fi

unsetopt correct_all
unsetopt correct

# set up fasd
eval "$(fasd --init auto zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zshwcomp-install)"
