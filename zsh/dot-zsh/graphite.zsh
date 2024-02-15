#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: /nix/store/mrdqyhd9giz1x29a0261cls5d3l67k8g-graphite-cli-0.22.1/bin/gt completion >> ~/.zshrc
#    or /nix/store/mrdqyhd9giz1x29a0261cls5d3l67k8g-graphite-cli-0.22.1/bin/gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /nix/store/mrdqyhd9giz1x29a0261cls5d3l67k8g-graphite-cli-0.22.1/bin/gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###
