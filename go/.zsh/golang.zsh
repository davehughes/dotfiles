# GOROOT
XGVM_VERSION=go1.6.2
XGVM_PKGSET=coin

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
gvm use $XGVM_VERSION >> /dev/null
gvm pkgset use $XGVM_PKGSET >> /dev/null
