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

alias mfa="~/bin/mfa.py --config=$HOME/.mfa"

alias tz='tizonia'

alias spotify='ncspot'

function kill-spotify {
  kill -9 $(ps ax | ag Spotify | head -n 1 | awk -F" " '{print $1}')
}
