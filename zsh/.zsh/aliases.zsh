# Always load tmux in 256 color mode
alias tmux="tmux -2"

alias node="env NODE_NO_READLINE=1 rlwrap node"

# fasd
alias v='fasd -fe vim'
alias vv='fasd -fise vim'
alias j='fasd_cd -d'
alias jj='fasd_cd -d -i'
alias l='fasd -de ls'
alias ll='fasd -dise ls'

alias vim="nvim"
alias oldvim="vim"

alias mfa="~/bin/mfa.py --config=$HOME/.mfa"
