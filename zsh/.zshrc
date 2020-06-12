# Theme setup - customize this per-machine for visual separation
# See list of themes in https://github.com/jimeh/tmux-themepack
export TMUX_THEME_COLOR='purple'
export TMUX_THEME="powerline/double/${TMUX_THEME_COLOR}"

source ~/.zfunctions
source ~/.oh-my.zsh

# load zsh config files
config_files=(~/.zsh/**/*.zsh(N))
for file in ${config_files}
do
  source $file
done

unsetopt correct_all
unsetopt correct
unsetopt nomatch
setopt complete_aliases

# set up fasd
eval "$(fasd --init auto zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zshwcomp-install)"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/dave/projects/sutrolabs/giza-webhooks-proxy/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/dave/projects/sutrolabs/giza-webhooks-proxy/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/dave/projects/sutrolabs/giza-webhooks-proxy/node_modules/tabtab/.completions/sls.zsh ]] && . /home/dave/projects/sutrolabs/giza-webhooks-proxy/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/dave/projects/sutrolabs/giza-webhooks-proxy/node_modules/tabtab/.completions/slss.zsh ]] && . /home/dave/projects/sutrolabs/giza-webhooks-proxy/node_modules/tabtab/.completions/slss.zsh