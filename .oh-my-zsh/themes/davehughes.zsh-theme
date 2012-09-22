EXPECTED_USERS=(d dave dshughe1)

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

function separator {
    separators=(► › ❯ ❱);
    echo "%{$C[separator]%}$separators[2]"
}

function vcs_section {
    top_level=`git rev-parse --show-toplevel 2>/dev/null`
    if [[ "$?" == 0 ]]; then
        echo `basename $top_level`:$(git_prompt_info)
    # else
    #     echo "<not in git>"
    fi
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
    # ${rvm_ruby}
    if [ "$VIRTUAL_ENV" ]; then
        env_base=`basename $VIRTUAL_ENV`
        if [[ "$env_base" == "env" ]]; then
            env_parent=`dirname $VIRTUAL_ENV`
            echo `basename $env_parent`
        else
            echo "$env_base"
        fi
    fi
}
#    
#    echo $VIRTUAL_ENV
#    if [[ "${#VIRTUAL_ENV}" == "0" ]]; then
#        echo $VIRTUAL_ENV
#    else
#        echo "<no virtualenv>"
#    fi
#    
#    # venvbase=`basename $VIRTUAL_ENV`
#    # basename $VIRTUAL_ENV
#    # if ( $venvbase == "env" ); then
#    #     echo "generic"
#    # else
#    #     echo "specific"
#    # fi
#    # echo " $(separator) $VIRTUAL_ENV"
#}

function box_section {
    # Output 'user@host' unless user is in EXPECTED_USERS, in which case just
    # output 'host'
    USER_STRING="%{$C[user]%}%n%{$C[at]%}@"
    for u in $EXPECTED_USERS; do
        if [[ "$u" == "$USER" ]]; then
            USER_STRING="" 
        fi
    done

    echo "$USER_STRING%{$C[host]%}$(box_name)"
}

PROMPT='$(box_section)%{$reset_color%}› '

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='%{$C[path]%}${PWD/#$HOME/~}$(vcs_section)$(env_section)${return_status}$(git_prompt_status)%{$reset_color%}'
