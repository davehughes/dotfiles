# GOROOT
XGVM_VERSION=go1.12
XGVM_PKGSET=global

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
gvm use $XGVM_VERSION >> /dev/null
gvm pkgset use $XGVM_PKGSET >> /dev/null
