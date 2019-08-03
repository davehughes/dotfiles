[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

gvm use go1.9.2 >> /dev/null
gvm pkgset use global >> /dev/null
