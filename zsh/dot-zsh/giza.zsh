export GIZA_HOME=${HOME}/projects/giza

NIX_DIRENV_HOME=${HOME}/projects/nix-direnv
eval "$(direnv hook zsh)"
source ${NIX_DIRENV_HOME}/direnvrc

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

function renix {
  pushd >>/dev/null; popd >>/dev/null
}
