source ~/.oh-my.zsh

# load zsh config files
config_files=(~/.zsh/**/*.zsh(N))
for file in ${config_files}
do
  source $file
done

unsetopt correct_all
unsetopt correct

# set up fasd
eval "$(fasd --init auto zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zshwcomp-install)"

bindkey "j" menu-complete
bindkey "k" reverse-menu-complete
