function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'


function env_info {
    echo "%{$FG[239]%}using%{$FG[243]%} ${rvm_ruby}"
}

typeset -A colors; colors=(
    connector 088 #031
    reset white
    user 108
    at 255
    host 108
    separator 088
    path 255
    # input green
    # status
)
C=colors
typeset -A C; C=();
for key in ${(@k)colors}; do
    C[$key]=$FG[$colors[$key]]
done

connector_top="%{$C[connector]%}╭─►"
connector_bottom="%{$C[connector]%}╰─▪"
# connector_top=╔═›
# connector_bottom=╚═▪
connector=1
tops=( ╭─►  ╔═› )
bots=( ╰─▪  ╚═▪ )

function connector_top    { echo "%{$C[connector]%}${tops[$connector]}" }
function connector_bottom { echo "%{$C[connector]%}${bots[$connector]}" }

#╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭
#╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯

function separator {
    separators=(► › ❯ ❱);
    echo "%{$C[separator]%}$separators[2]"
}

function path_section {
    echo " $(separator) %{$C[path]%}${current_dir}"
}

function vcs_section {
    git branch >/dev/null 2>/dev/null
    echo "%(?, $(separator) $(git_prompt_info),)"
}

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

function env_section {
    # TODO: ruby/rvm
    
    # if [[ ${#VIRTUAL_ENV} == 0 ]]; then
    #     echo $VIRTUAL_ENV
    # else
    #     echo "<no virtualenv>"
    # fi
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
    
    # venvbase=`basename $VIRTUAL_ENV`
    # basename $VIRTUAL_ENV
    # if ( $venvbase == "env" ); then
    #     echo "generic"
    # else
    #     echo "specific"
    # fi
    # echo " $(separator) $VIRTUAL_ENV"
}

function box_section {
    echo "%{$C[user]%}%n%{$C[at]%}@%{$C[host]%}$(box_name)"
}

PROMPT="$(connector_top) $(box_section)$(path_section)$(vcs_section)$(env_section)
$(connector_bottom) %{$reset_color%}"

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}$(git_prompt_status)%{$reset_color%}'
