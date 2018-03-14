EXPECTED_USERS=()

local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi

typeset -A colors; colors=(
    reset white
    user 009
    at 255
    host 009
    separator 007
    path 014
    env 002
    repo_name 004
    repo_branch 003
    error_code 001
)
C=colors
typeset -A C; C=();
for key in ${(@k)colors}; do
    C[$key]=$FG[$colors[$key]]
done

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

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

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

function separator {
    separators=(► › ❯ ❱);
    echo "%{$C[separator]%}$separators[2]"
}

function combined_location {
    # Combine path, virtualenv, and git repository into a minimized location
    # string

    REPO_BASE=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ "$?" == 0 ]]; then
        REPO_NAME=$(basename $REPO_BASE)
    fi

    if [ "${+VIRTUAL_ENV}" != "0" ]; then
        ENV_NAME=$(basename $VIRTUAL_ENV)

        # If virtualenv is generically named, use its parent directory name instead
        if [[ "$ENV_NAME" == "env" ]]; then
            ENV_PARENT=$(dirname $VIRTUAL_ENV)
            ENV_NAME=$(basename $ENV_PARENT)
        fi
    fi

    SEGMENTS=()
    # Add the full environment name if it differs from the repository name, 
    # or just add a highlight otherwise
    if [ "$ENV_NAME" ]; then
        if [[ "$ENV_NAME" == "$REPO_NAME" ]]; then
            ENV_HIGHLIGHT="%{$C[env]%}★ %{$reset_color%}"
        else
            SEGMENTS+=("%{$C[env]%}$ENV_NAME")
        fi
    fi
    
    if [ "$REPO_NAME" ]; then
        SEGMENTS+=("$ENV_HIGHLIGHT%{$C[repo_name]%}$REPO_NAME%{$C[separator]%}:%{$C[repo_branch]%}$(git_prompt_info)")
    fi

    which gvm-prompt && SEGMENTS+=("$(gvm-prompt)") 

    # Set location string relative to current repo and home directories
    LPATH=${PWD}
    if [ "$REPO_NAME" ]; then
        LPATH=${LPATH/#$REPO_BASE/}
        LPATH=${LPATH/\//}
    fi
    
    LPATH="${LPATH/#$HOME/~}"

    ## Add the path segment if it has non-zero length
    if [ "${#LPATH}" != "0" ]; then
        SEGMENTS+=("%{$C[path]%}$LPATH")
    fi

    ## Join segments with separators - man, am I terrible at zsh scripting!
    echo "$(echo "${(j:^:)SEGMENTS}" | sed "s/\^/ $(separator) /g")$(git_prompt_status)"
}

PROMPT='$(box_section)%{$C[separator]%}› %{$reset_color%}'

local return_status="%{$C[error_code]%}%(?.. [%?])%{$reset_color%}"
#RPROMPT='%{$C[path]%}${PWD/#$HOME/~}$(vcs_section)$(env_section)$(git_prompt_status)${return_status}%{$reset_color%}'
RPROMPT='$(combined_location)${return_status}%{$reset_color%}'
