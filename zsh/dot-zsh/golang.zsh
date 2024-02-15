[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# These instructions worked on OSX to bootstrap as of 2021-12-10
# https://github.com/moovweb/gvm/issues/360
gvm use go1.19>> /dev/null
gvm pkgset use global >> /dev/null
