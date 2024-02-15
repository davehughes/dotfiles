# The normal `upgrade_oh_my_zsh` is broken because stowing our custom themes/plugins requires minor
# surgery on the .oh-my-zsh git repo, which conflicts with the upgrade mechanism.

function -upgrade_oh_my_zsh {
  pushd ~/.oh-my-zsh >>/dev/null
  rm -rf custom
  git reset --hard HEAD
  upgrade_oh_my_zsh
  rm -rf custom
  popd >>/dev/null

  pushd ~/.dotfiles >>/dev/null
  stow -R zsh
  popd >>/dev/null
}
