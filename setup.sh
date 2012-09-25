#!/bin/bash
SCRIPT=`readlink -f $0`
SCRIPTDIR=`dirname $SCRIPT`
cd $SCRIPTDIR
echo "running in $SCRIPTDIR"

echo "symlinking dotfiles from $SCRIPTDIR to $HOME"
for f in .* ; do
    [ $f = '.' ] && continue
    [ $f = '..' ] && continue
    [ $f = '.git' ] && continue
    [ $f = '.gitignore' ] && continue
    [ $f = '.ssh' ] && continue
    ln -sfbn $SCRIPTDIR/$f $HOME/$f
    echo "$SCRIPTDIR/$f --> $HOME/$f"
done

for f in .ssh/* ; do
    ln -sfbn $SCRIPTDIR/$f $HOME/$f
    echo "$SCRIPTDIR/$f --> $HOME/$f"
done

# symlink bin directory
ln -sfbn $SCRIPTDIR/bin $HOME/bin
echo "$SCRIPTDIR/bin --> $HOME/bin"

git submodule update --init --recursive


# Build vimclojure-nailgun-client
cd /tmp
NGCLIENT_VERSION="2.2.0"
NGCLIENT_PACKAGE="vimclojure-nailgun-client"
wget -O "$NGCLIENT_PACKAGE.zip" "http://kotka.de/projects/vimclojure/$NGCLIENT_PACKAGE-$NGCLIENT_VERSION.zip"
unzip -o "$NGCLIENT_PACKAGE.zip"
cd $NGCLIENT_PACKAGE
make
mv ng $SCRIPTDIR/.vim/bin
cd $SCRIPTDIR

# Install flake8 for syntastic vim plugin
pip install flake8

