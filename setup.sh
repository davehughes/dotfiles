#!/bin/zsh
#SCRIPT=`readlink -f $0`
SCRIPT=`stat -f $0`
SCRIPTDIR=`dirname $SCRIPT`

pushd $SCRIPTDIR
echo "running in $SCRIPTDIR"

# Install vundle and plugins
mkdir -p .vim/bundle
git clone git://github.com/gmarik/vundle .vim/bundle/vundle
vim +PluginInstall +qall

echo "symlinking dotfiles from $SCRIPTDIR to $HOME"
for f in .* ; do
    [ $f = '.' ] && continue
    [ $f = '..' ] && continue
    [ $f = '.git' ] && continue
    [ $f = '.gitignore' ] && continue
    [ $f = '.ssh' ] && continue
    ln -sfn $SCRIPTDIR/$f $HOME/$f
    echo "$SCRIPTDIR/$f --> $HOME/$f"
done

for f in .ssh/* ; do
    ln -sfn $SCRIPTDIR/$f $HOME/$f
    echo "$SCRIPTDIR/$f --> $HOME/$f"
done

# symlink bin directory
ln -sfn $SCRIPTDIR/bin $HOME/bin
echo "$SCRIPTDIR/bin --> $HOME/bin"

popd
