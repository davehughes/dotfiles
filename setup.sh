#!/bin/sh
SCRIPT=`readlink -f $0`
SCRIPTDIR=`dirname $SCRIPT`

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

git submodule init
git submodule update

CMDT_RUBY_DIR=$SCRIPTDIR/.vim/bundle/command-t/ruby/command-t
ruby $CMDT_RUBY_DIR/extconf.rb
make -C $CMDT_RUBY_DIR
