# source tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# tmuxinator completion
# (from https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh)
_tmuxinator() {
  local commands projects
  commands=(${(f)"$(tmuxinator commands zsh)"})
  projects=(${(f)"$(tmuxinator completions start)"})

  if (( CURRENT == 2 )); then
    _describe -t commands "tmuxinator subcommands" commands
    _describe -t projects "tmuxinator projects" projects
  elif (( CURRENT == 3)); then
    case $words[2] in
      copy|debug|delete|open|start)
        _arguments '*:projects:($projects)'
      ;;
    esac
  fi

  return
}

compdef _tmuxinator tmuxinator mux
alias mux="tmuxinator"
alias tmux-layout="tmux display-message -p '#{window_layout}'"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
