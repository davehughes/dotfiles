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
