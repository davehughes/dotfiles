RBENV_ROOT_DEFAULT="$HOME/.rbenv"
RBENV_ROOT=${RBENV_ROOT:-$1}
RBENV_ROOT=${RBENV_ROOT:-$RBENV_ROOT_DEFAULT}

echo "Installing rbenv to $RBENV_ROOT"
[[ -d $RBENV_ROOT ]] || git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT
cd $RBENV_ROOT && src/configure && make -C src

mkdir -p $RBENV_ROOT/plugins

echo "Installing rbenv-update plugin"
TARGET="$RBENV_ROOT/plugins/rbenv-update"
[[ -d $TARGET ]] || git clone https://github.com/rkh/rbenv-update "$TARGET"

echo "Installing ruby-build as rbenv plugin"
TARGET="$RBENV_ROOT/plugins/ruby-build"
[[ -d $TARGET ]] || git clone https://github.com/rbenv/ruby-build "$TARGET"

echo "Installing ctags as rbenv plugin"
TARGET="$RBENV_ROOT/plugins/rbenv-ctags"
[[ -d $TARGET ]] || git clone https://github.com/tpope/rbenv-ctags "$TARGET"

echo "Updating rbenv and installed plugins"
$RBENV_ROOT/bin/rbenv update
